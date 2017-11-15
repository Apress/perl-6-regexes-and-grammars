my $str = 'Amanda sighed. "It was madness", she said. '
        ~ '"Sheer madness"';
if $str ~~ / \" .* \" / {
    say $/.Str;
}
