my $str = "If I had a hammer, I'd hammer in the morning";
say $str.match(:global, /h.mm\w*/).join('|');

say 'Hello, world'.match(/:i hello/);   # Output: ⌜Hello⌟

say ('abc' ~~ m:g/./).elems;    # Output: 3

