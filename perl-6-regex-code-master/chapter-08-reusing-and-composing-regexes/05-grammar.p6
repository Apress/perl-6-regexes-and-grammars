grammar IPv4Address {
    token byte {
        \d ** 1..3
        <?{ $/.Int <= 255 }>
    }
    token TOP {
        <byte> ** 4 % '.'
    }
}

my $str = '127.0.0.1';
if IPv4Address.parse($str) {
    say join ', ', $<byte>.list;
        # Output:  127, 0, 0, 1
}

say IPv4Address.subparse($str, :rule<byte>);   # Output: ⌜127⌟
say IPv4Address.parse($str, :rule<byte>);      # Output: Nil
