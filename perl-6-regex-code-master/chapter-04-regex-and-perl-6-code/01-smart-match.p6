my $str = "If I had a hammer, I'd hammer in the morning";
say $str ~~ /h.mm\w*/;      # Output: ⌜hammer⌟
say $str ~~ /hummer/;       # Output: Nil
