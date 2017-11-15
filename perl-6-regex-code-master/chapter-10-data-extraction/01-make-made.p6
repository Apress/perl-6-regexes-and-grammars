if 'abc' ~~ /\w/ {
    $/.make({'a' => 'bc'});
    say $/.made;    # Output: {a => bc}
}

if 'abc' ~~ /\w/ {
    make {'a' => 'bc'};
    say $/.made;    # Output: {a => bc}
}

