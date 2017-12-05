my token number { \d+ }
my rule  sum    { <number> '+' <number> }

say '1+2'   ~~ / ^ <sum> $ /;
say '1 + 2' ~~ / ^ <sum> $ /;

say "a a" ~~ rule  { a+ };
say "a a" ~~ rule  { a + };

say 'ab' ~~ rule { a b }    # Output: Nil

