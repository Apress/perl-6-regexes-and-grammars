for 0..0x1FFFF -> $c {
    if chr($c) ~~ /\n/ {
        printf "U+%05X - %s\n", $c,  $c.uniname
    }
}
