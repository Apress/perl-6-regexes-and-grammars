my regex byte {
    \d ** 1..3
    <?{ $/.Int <= 255 }>
}

my $str = '127.0.0.1';
say $str ~~ / ^ <byte> ** 4 % '.' $ /;

say &byte.^name;        # Output: Regex
say &byte ~~ Code;      # Output: True
