grammar MathExpression {
    token TOP    { <sum> }
    rule sum     { <product>+ %  '+' }
    rule product { <term>+ % '*' }
    rule term    { <number> | <group> }
    rule group   { '(' <sum> ')' }
    token number { \d+ }
}

say MathExpression.parse('2 + 4 * 5 * (1 + 3)');
