class SymbolTable {
    has @!scopes = {}, ;
    method enter-scope() {
        @!scopes.push({})
    }
    method leave-scope() {
        @!scopes.pop();
    }
    method declare($variable) {
        @!scopes[*-1]{$variable} = True
    }
    method check-declared($variable) {
        for @!scopes.reverse -> %scope {
            return True if %scope{$variable};
        }
        return False;
    }
}

grammar VariableLists {
    token TOP {
        :my $*ST = SymbolTable.new();
        <statement>*
    }
    token ws { <!ww> \h* }
    token statement {
        | <declaration>
        |  <block>
    }
    rule declaration {
        <identifier>
        { $*ST.declare( $<identifier> ) }
        '=' <termlist>
        \n
    }
    method block {
        $*ST.enter-scope();
        LEAVE $*ST.leave-scope();
        self.block_wrapped();
    }

    rule block_wrapped {
        '{' \n*
            <statement>*
        '}' \n*
    }
    rule termlist { <term> * % ',' }
    token term { <variable> | <number> }
    token variable {
        <identifier>
        <?{ $*ST.check-declared($<identifier>) }>
    }
    token number { \d+ }
    token identifier { <:alpha> \w* }
}

my $input-accept = q:to/EOF/;
a = 1
{
    b = 2
    {
        c = a, 5, b
    }
}
EOF

my $input-reject = q:to/EOF/;
a = 1
{
    b = 2
}
c = a, 5, b
EOF

use Test;
plan 2;

ok  VariableLists.parse($input-accept);
nok VariableLists.parse($input-reject);
