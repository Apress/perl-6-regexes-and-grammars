say "abc" ~~ /ab | a.* /;       # Output: ⌜abc⌟
say "abc" ~~ /ab | a {} .* /;   # Output: ⌜ab⌟
