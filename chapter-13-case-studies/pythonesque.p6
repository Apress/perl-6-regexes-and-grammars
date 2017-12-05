
class Operator {
    has Str $.action is required;
    multi method gist(Operator:D:) { "op $.action" }
}
class Variable {
    has Str $.name is required;
    multi method gist(Variable:D:) { "var $.name" }
}

class If {
    has $.condition;
    has @.block;
    multi method gist(If:D:) {
        "if " ~ $.condition.gist ~ ' {' ~ @.block.gist ~ '}'
    }
}

class Pythonesque::Actions {
    has @.scopes;
    method TOP($/)  {
        make @.scopes[0];
    }
    method line($/) {
        @.scopes[*-1].push($<statement>.made)
    }
    method enter_scope($/) { @.scopes.push([]) }
    method leave_scope($/) {
        if @.scopes > 1 {
            my $last = @.scopes.pop;
            @.scopes[*-1][*-1].block = $last.list;
        }
    }

    method statement:sym<if>($/) {
        make If.new(condition => $<expression>.made);
    }
    method statement:sym<expression>($/) {
        make $<expression>.made;
    }
    method expression($/) { make $/.caps».value».made.Array }
    method identifier($/) { make Variable.new(name => $/.Str) }
    method term($/)     { make $/.caps[0].value.made; }
    method number($/)   { make $/.Int }
    method operator($/) { make Operator.new(action => $/.Str) }
}

# an exception class makes it easier to test for
# specific error conditions in unit tests, but also
# in regular code
enum ErrorMode <TooMuch TooLittle NotSeenBefore>;
class X::Pythonesque::WrongIndentation is Exception {
    has Int $.got is required;
    has Int $.expected;
    has ErrorMode $.mode is required;
    method message() {
        if $.mode == TooMuch {
            return "Inconsistent indentation: expected "
                 ~ "at most $.expected, got $.got spaces";
        }
        elsif $.mode == TooLittle {
            return "Inconsistent indentation: expected "
                 ~ "more than $.expected, got $.got spaces";
        }
        else {
            return "Unexpected indentation level: $.got.";
        }
    }
}

grammar Pythonesque {
    my class NEW_INDENTATION { }
    method handle_indentation($match) {
        my $current = $match.Str.chars;
        my $last = @*INDENTATION[*-1];
        if $last ~~ NEW_INDENTATION {
            my $before = @*INDENTATION[*-2];
            if $current > $before {
                @*INDENTATION[*-1] = $current;
                self.enter_scope();
            }
            else {
                X::Pythonesque::WrongIndentation.new(
                    got      => $current,
                    expected => $before,
                    mode     => TooLittle,
                ).throw;
            }
        }
        elsif $current > $last {
                X::Pythonesque::WrongIndentation.new(
                    got      => $current,
                    expected => $last,
                    mode     => TooMuch,
                ).throw;
        }
        elsif $current < $last {
            my $idx = @*INDENTATION.first(:k, $current);
            if defined $idx {
                for $idx + 1 .. @*INDENTATION.end {
                    @*INDENTATION.pop;
                    self.leave_scope();
                }
            }
            else {
                X::Pythonesque::WrongIndentation.new(
                    got      => $current,
                    mode     => NotSeenBefore,
                ).throw;
            }
        }

    }
    token enter_scope { <?> }
    token leave_scope { <?> }
    token TOP {
        :my @*INDENTATION = (0,);
        <.enter_scope>
        <line>*
        $

        # leave all open scopes:
        { self.handle_indentation('') }
        <.leave_scope>
    }
    token line {
        ^^ ( \h* ) { self.handle_indentation($0) }
        <statement>  $$ \n*
    }
    token ws { \h* }
    proto token statement { * }
    rule statement:sym<if> {
        'if'  <expression> ':'
        { @*INDENTATION.push(NEW_INDENTATION) }
    }
    token statement:sym<expression> {
        <expression>
    }
    rule expression  { <term> + % <operator>   }
    token term       { <identifier> | <number> }
    token number     { \d+                     }
    token identifier { <:alpha> \w*            }
    token operator   {
        <[-+=<>*/]> | '==' | '<=' | '>=' | '!='
    }
}


use Test;

# example from the start of the section
my $sample = q:to/EOF/;
a = 1
if a:
    x = 1
    y = 2
    if x + 1 < 3:
          z = x + y
    a = z * 4
b = 5
EOF

# corresponding AST:
my $expected = [
    [Variable.new(name => "a"), Operator.new(action => "="), 1],
    If.new(condition => [Variable.new(name => "a")],
           block => [
            [Variable.new(name => "x"), Operator.new(action => "="), 1],
            [Variable.new(name => "y"), Operator.new(action => "="), 2],
            If.new(condition => [Variable.new(name => "x"), Operator.new(action => "+"), 1, Operator.new(action => "<"), 3],
                block => [
                    [Variable.new(name => "z"), Operator.new(action => "="), Variable.new(name => "x"), Operator.new(action => "+"), Variable.new(name => "y")],
                ]),
            [Variable.new(name => "a"), Operator.new(action => "="), Variable.new(name => "z"), Operator.new(action => "*"), 4]
        ]
    ),
    [Variable.new(name => "b"), Operator.new(action => "="), 5]
];

my $actions = Pythonesque::Actions.new;
my $m = Pythonesque.parse($sample, actions => $actions);
ok $m, 'Parsed sample input string';
is-deeply $actions.scopes[0],
    $expected,
    "Correct AST for sample input string";


# the third line should be indented more than the second line,
# so this triggers an error with TooLittle indentation
my $too-little = q:to/EOF/;
if 1:
    if 2:
    b = 3
EOF

throws-like { Pythonesque.parse($too-little) },
    X::Pythonesque::WrongIndentation,
    mode => TooLittle;


# The second line should have the same indentation as the first:
my $too-much = q:to/EOF/;
a = 2
    b = 3
EOF

throws-like { Pythonesque.parse($too-much) },
    X::Pythonesque::WrongIndentation,
    mode => TooMuch;


# The following example features an indentation
# level that hasn't been seen before:
my $inconsistent = q:to/EOF/;
if 1:
    a = 2
  b = 3
EOF


throws-like { Pythonesque.parse($inconsistent) },
    X::Pythonesque::WrongIndentation,
    mode => NotSeenBefore;


# This example tests for an error condition that was present
# in the first iteration of the parser, where nested scopes
# at the end of the input were not correctly processed:
my $input = q:to/EOF/;
if 1:
    if 2:
        x = 2
EOF

$m = Pythonesque.parse($input, actions => Pythonesque::Actions.new);
ok $m, "Can parse program that ends in if-statement";

is-deeply
    $m.made,
    [If.new(
        condition => [1],
        block => [
            If.new(
                condition => [2],
                block => [
                    [Variable.new(name => "x"), Operator.new(action => "="), 2],
                ]
            )
        ]
    )],
    "Scope leaving works at the end of the program";

done-testing;
