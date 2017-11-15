my token byte {
    \d ** 1..3
    <?{ $/.Int <= 255 }>
}

my $str = '127.0.0.1';
say $str ~~ / ^ <byte> ** 4 % '.' $ /;
