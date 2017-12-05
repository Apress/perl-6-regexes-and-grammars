for '/usr/share/dict/words'.IO.lines -> $word {
    say $word if lc($word) ~~ / ^ .e.rl $ /;
}
