grammar MathExpression {
    token TOP           { <sum> }
    rule sum            { <multiplication>+ %  '+' }
    rule multiplication { <term>+ % '*' }
    rule term           { <number> | <group> }
    rule group  {
         '(' <sum>
       [ ')' || <error("no closing ')'")> ]
    }
    token number        { \d+ }

    method error($msg) {
        my $parsed = self.target.substr(0, self.pos);
        my $line-no = $parsed.lines.elems;
        die "Cannot parse mathematical expression: "
            ~ "$msg at line $line-no";
    }
}

say MathExpression.parse("(\n1");
