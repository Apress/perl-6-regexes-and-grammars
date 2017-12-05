use Grammar::ErrorReporting;

class Operator {
    has Str $.symbol is required;
    has Numeric $.precedence  is required;
    method new(Str $symbol, Numeric $precedence) {
        self.bless(:$symbol, :$precedence);
    }
}

grammar MathExpression does Grammar::ErrorReporting {
    rule TOP { <.ws> <expression> }
    rule expression { <term> + % <infix> }

    proto token infix   { * }
    token infix:sym<*>  { <sym> }
    token infix:sym</>  { <sym> }
    token infix:sym<+>  { <sym> }
    token infix:sym<->  { <sym> }
    token infix:sym<**> { <sym> }

    proto token term { * }
    token term:sym<integer> {
        <[+-]>? <[0..9]>+
    }
    rule term:sym<parenthesized> {
        '(' ~ ')' <expression>
    }
    rule term:sym<function> {
        <name=.identifier> '(' ~ ')' <expression>
    }
    token identifier { <[a..z]>+ }
}

class MathActions {
    method opp-parse(@tokens) {
        sub opp-reduce(@stack) {
            my ($term1, $op, $term2) = @stack.splice(*-3, 3);
            @stack.push([$op, $term1, $term2]);
        }

        my %prec = '+' => 1, '-' => 1,
                   '*' => 2, '/' => 2,
                   '**'  => 3;

        my @stack = @tokens[0];
        for @tokens[1..*] -> $op, $term {
            opp-reduce(@stack)
                while @stack >= 3
                   && $op.precedence <= @stack[*-2].precedence;
            @stack.push($op, $term);
        }
        opp-reduce(@stack) while @stack > 1;
        return @stack[0];
    }
    method TOP($/) { make $<expression>.made }
    method expression($/) {
        my @tokens = $/.caps.map({.value.made});
        make self.opp-parse(@tokens);
    }
    method infix:sym<+>($/)  { make Operator.new(~$<sym>, 1) }
    method infix:sym<->($/)  { make Operator.new(~$<sym>, 1) }
    method infix:sym<*>($/)  { make Operator.new(~$<sym>, 2) }
    method infix:sym</>($/)  { make Operator.new(~$<sym>, 2) }
    method infix:sym<**>($/) { make Operator.new(~$<sym>, 3) }

    method term:sym<integer>($/) { make $/.Int }
    method term:sym<parenthesized>($/) {
        make $<expression>.made;
    }
    method term:sym<function>($/) {
        make [$<name>.made, $<expression>.made];
    }
    method identifier($/) { make $/.Str }
}


sub parse-math-expression(Str $input) {
    my $match = MathExpression.parse($input,
        actions => MathActions.new);
    die "Cannot parse input" unless $match;
    return $match.made;
}

say parse-math-expression('1 + 2 * 3**4 * 5 + 6');
