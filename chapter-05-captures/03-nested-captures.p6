'abcdef' ~~ /(.) (b(c)(d(e))) /;
say $0.Str;         # Output: a
say $1.Str;         # Output: bcde
say $1[0].Str;      # Output: c
say $1[1].Str;      # Output: de
say $1[1][0].Str;   # Output: e
