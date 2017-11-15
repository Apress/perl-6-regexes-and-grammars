my $str = 'Hello, World';
if $str ~~ / $<greeting>=[\w+] ', ' $<audience>=[\w+] / {
    say $<greeting>.Str;        # Output: Hello
    say $<audience>.Str;        # Output: World
}

{
    my regex byte {
        \d ** 1..3
        <?{ $/.Int <= 255 }>
    }

    my $str = '127.0.0.1';
    if $str ~~ / ^ <byte> ** 4 % '.' $ / {
        for $<byte>.list -> $byte {
            say $byte.Str;
        }
    }
}

{
    my $str = 'Hello, World';
    my regex word { \w+ };

    if $str ~~ /<greeting=word> ', ' <audience=word>/ {
        say $<greeting>.Str;        # Output: Hello
        say $<audience>.Str;        # Output: World
    }
}
