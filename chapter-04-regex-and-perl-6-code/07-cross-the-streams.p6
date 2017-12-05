my $word-regex = /\w+/;
say "Hello, world" ~~ $word-regex;  # Output: ⌜Hello⌟

{
    my $audience = 'world';
    my $greeting = 'Hello';

    if "Hello, world" ~~ / $greeting ', ' $audience / {
        # this branch is executed
    }
}

{
    my $audience = "\\w+";
    my $greeting = 'Hello';

    if "Hello, world" ~~ / $greeting ', ' <$audience> / {
        # this branch is executed
    }
}

{
    my $count = 0;

    my $str = "between 23 and 42 numbers";

    if $str ~~ / [ \d+ { $count++ } \D* ]+ / {
        say $count;     # Output: 2
    }
}

say '1.0e42' ~~ / ^ \d+ ['.' \d+]? [e|E \d+]? $ /;

'1.0e42' ~~ / ^
    \d+        { say "integer: '$/'" }
    ['.' \d+]  { say "decimal place: '$/'" }
    [e|E \d+]  { say "exponent: '$/'" }
    $ /;


my $one-byte = / ^ \d ** 0..3 $ <?{ $/.Int <= 255 }> /;
for 0, 100, 255, 256, 1000 -> $num {
    if $num ~~ $one-byte {
        say $num;
    }
}

