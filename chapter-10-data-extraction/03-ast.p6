grammar MathExpression {
    token TOP    { <sum> }
    rule sum     { <product>+ %  '+' }
    rule product { <term>+ % '*' }
    rule term    { <number> | <group> }
    rule group   { '(' <sum> ')' }
    token number { \d+ }
}

class MathASTAction {
    method reduce($op, @list) {
        return @list[0] if @list.elems == 1;
        return [$op, |@list];
    }
    method TOP($/) {
        make $<sum>.made;
    }
    method sum($/) {
        make self.reduce('+', $<product>».made);
    }
    method product($/) {
        make self.reduce('*', $<term>».made);
    }
    method term($/) {
        make $/.values[0].made;
    }
    method group($/) {
        make $<sum>.made;
    }
    method number($/) {
        make $/.Int;
    }
}

my $match = MathExpression.parse(
    '4 + 5 * (1 + 3)',
    actions => MathASTAction.new,
);
say $match.made.perl;
