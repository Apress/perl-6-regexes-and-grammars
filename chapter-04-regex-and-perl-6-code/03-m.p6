$_ = 'abc';
if m/b./ {
    say "match";
}

say "abc" ~~ m/b/;      # Output: ⌜b⌟
