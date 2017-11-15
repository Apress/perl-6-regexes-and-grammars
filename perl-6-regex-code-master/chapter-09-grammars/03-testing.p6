grammar MathExpression {
    token number { \d+ }
    rule product { <number>+ % '*' }
}

multi sub MAIN(Bool :$test!) {
    use Test;
    plan 5;
    ok MathExpression.parse('1234', :rule<number>),
        '<number> parses 1234';
    nok MathExpression.parse('1+4', :rule<number>),
        '<number> does not parse 1+4';

    ok MathExpression.parse('1234', :rule<product>),
        '<product> can parse a simple number';
    ok MathExpression.parse('1*3*4', :rule<product>),
        '<product> can parse three terms';
    ok MathExpression.parse('1 * 3', :rule<product>),
        '<product> and whitespace';
}
