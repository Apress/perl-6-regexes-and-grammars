say "e\c[COMBINING GRAVE ACCENT]".chars;        # Output: 1

if "e\c[COMBINING GRAVE ACCENT]" ~~ / ^ . $ / {
    say "A single grapheme cluster";
}

