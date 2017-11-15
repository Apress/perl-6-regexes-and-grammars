if "127.0.0.1" ~~ /(\d+)**4 % "."/ {
    say $0.elems;       # Output: 4
    say $0[3].Str;      # Output: 1
}
