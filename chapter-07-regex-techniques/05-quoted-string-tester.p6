my regex quoted {
    \"  # opening quote
    [
          <-[ " \\ ]>  # regular character
        | \\ .         # escape sequence
    ]*
    \" # closing quote
}

multi sub MAIN(Bool :$test!) {
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
}

multi sub MAIN($input) {
    if $input ~~ / ^ <quoted> $ / {
        say "$input is a quoted string";
    }
    else {
        say "invalid input: $input";
        exit 1;
    }
}

