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
        my $parsed = self.target.substr(0, self.pos)\
                     .trim-trailing;
        my $context = $parsed.substr($parsed.chars - 10 max 0)
              ~ '⏏' ~ self.target.substr($parsed.chars, 10);
        my $line-no = $parsed.lines.elems;
        die "Cannot parse mathematical expression: $msg\n"
            ~ "at line $line-no, around " ~ $context.perl
            ~ "\n(error location indicated by ⏏)\n";
    }
}

try MathExpression.parse("(\n1");
say $!.message;

try MathExpression.parse("(1 + 2 5");
say $!.message;
