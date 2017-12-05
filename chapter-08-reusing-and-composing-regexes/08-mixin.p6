grammar JSONValue {
    proto token value {*};
    token value:sym<true>  { <sym> }
    token value:sym<false> { <sym> }
    token value:sym<null>  { <sym> }
    token TOP { <value> }
}

role DateValue {
    token value:sym<date> {
        <[0..9]>**4 '-' <[0..9]>**2 '-' <[0..9]>**2
    }
}

grammar JSONValueWithDate is JSONValue does DateValue { };

for <true null 2015-12-24 42> -> $str {
    say $str, ': ', ?JSONValueWithDate.parse($str);
}

for <true null 2015-12-24 42> -> $str {
    say $str, ': ', ?(JSONValue but DateValue).parse($str);
}


role IntegerValue {
    token value:sym<integer> { <[0..9]>+ }
}

my $grammar = (JSONValue but DateValue) but IntegerValue;

for <true null 2015-12-24 42> -> $str {
    say $str, ': ', ?$grammar.parse($str);
}



