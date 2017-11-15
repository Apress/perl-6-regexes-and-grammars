say '"a,b","' ~~ / \" <-["]>* \" /;         # Output: ⌜"a,b"⌟
say '"a,b","' ~~ / ^ \" <-["]>* \"  $ /;    # Output: Nil
