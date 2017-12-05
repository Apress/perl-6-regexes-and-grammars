my regex a { . };
say "x" ~~ &a;          # Output: ⌜x⌟

say "x" ~~ / <a> /;     # Output: ⌜x⌟

