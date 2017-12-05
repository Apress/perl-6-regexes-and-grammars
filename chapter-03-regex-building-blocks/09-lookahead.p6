say 'up to 200 MB' ~~ / \d+ <?before \s* <[kMGT]>? B > /;
    # Output: ⌜200⌟

say 'up to 200 MB' ~~ / \d+ <!before \s* <[kMGT]>? B > /;
    # Output: ⌜20⌟

say 'up to 200 MB' ~~ / « \d+ » <!before \s* <[kMGT]>? B > /;
    # Output:  Nil

say '200,50' ~~ / <?after \, > \d+ /;   # Output: ⌜50⌟

say '200,50' ~~ / <!after \, > \d+ /;   # Output: ⌜200⌟
