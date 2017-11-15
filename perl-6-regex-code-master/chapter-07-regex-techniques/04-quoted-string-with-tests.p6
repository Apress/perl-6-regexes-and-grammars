my regex quoted {
    \"  # opening quote
    [
          <-[ " \\ ]>  # regular character
        | \\ .         # escape sequence
    ]*
    \" # closing quote
}

my @should-match =
    Q<"abc">,
    Q<"abc\\">,
    Q<"ac\\def\"ef">,
    ;

my @should-not-match =
    Q<abc>,
    Q<"abc"def">,
    Q<"ab\\"cdef">,
    ;

use Test;
plan 6;

for @should-match -> $s {
    ok $s ~~ / ^ <quoted> $ /,
        "Successful match of string $s";
}
for @should-not-match -> $s {
    nok $s ~~ / ^ <quoted> $ /,
        "Successful rejection of string $s";
}
