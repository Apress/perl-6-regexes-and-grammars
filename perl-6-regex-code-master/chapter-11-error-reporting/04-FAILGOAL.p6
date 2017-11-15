grammar MathExpression {
    token TOP    { <sum> }
    rule sum     { <product>+ %  '+' }
    rule product { <term>+ % '*' }
    rule term    { <number> | <group> }
    rule group   { '(' ~ ')' <sum> }
    token number { \d+ }

    method FAILGOAL($goal) {
        my $cleaned = $goal.trim;
        self.error("No closing $cleaned");
    }

    method error($msg) {
        my $parsed = self.target.substr(0, self.pos).trim-trailing;
        my $context = $parsed.substr($parsed.chars - 10 max 0)
                      ~ '⏏' ~ self.target.substr($parsed.chars, 10);
        my $line-no = $parsed.lines.elems;
        die "Cannot parse mathematical expression: $msg\n"
            ~ "at line $line-no, around " ~ $context.perl
            ~ "\n(error location indicated by ⏏)\n";
    }
}

MathExpression.parse('(1');
