grammar MathExpression {
    method parse($target, |c) {
        my $*HIGHWATER = 0;
        my $*LASTRULE;
        my $match = callsame;
        self.error($target) unless $match;
        return $match;
    }
    token TOP    { <sum> }
    rule sum     { <product>+ %  '+' }
    rule product { <term>+ % '*' }
    rule term    { <number> | <group> }
    rule group   {
        '(' <sum> ')'
    }
    token number        { \d+ }
    method ws()  {
        if self.pos > $*HIGHWATER {
            $*HIGHWATER = self.pos;
            $*LASTRULE = callframe(1).code.name;
        }
        callsame;
    }

    method error($target) {
        my $parsed = $target.substr(0, $*HIGHWATER).trim-trailing;
        my $line-no = $parsed.lines.elems;
        my $msg = "Cannot parse mathematical expression";
        $msg ~= "; error in rule $*LASTRULE" if $*LASTRULE;
        die "$msg at line $line-no";
    }
}

say MathExpression.parse("1 + ");
