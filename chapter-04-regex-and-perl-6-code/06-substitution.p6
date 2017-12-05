say '42 eur'.subst( rx:i/ « eur » /, '€');    # Output: 42 €

say '42 €'.subst(/\s+/, '');                  # Output: 42€

say '1 2 3'.subst(/\s+/, '');                 # Output: 12 3
say '1 2 3'.subst(:g, /\s+/, '');             # Output: 123

say "9 of spades".subst(/\d+/, -> $m { $m + 1 });
    # Output: 10 of spades

say "9 of spades".subst(/(\d+)/, -> $/ { $0 + 1 });
    # Output: 10 of spades

my $var = '1 2 3';
$var ~~ s:g/ \s+ //;
say $var;                                     # Output: 123

{
    my $var = '"fantastic", she said';
    $var ~~ s:g/ \" (.*?) \" /«$0»/;
    say $var;           # Output: «fantastic», she said
}

my $ad = 'Buy now! USD 10 per book. Prices double soon to 20.';
$ad ~~ s:g[ \d+ ] = 2 * $/;
say $ad;

my $input = "It's just a jump to the left.
And then a step to the right.";

$input ~~ s:g/ <?before jump> /⇑/;
$input ~~ s:g/ <?before left> /←/;
$input ~~ s:g/ <?after right> /→/;

say $input;

{
    my $input = '2 links with 75MB each';
    say $input.subst(:g, / \d+ <?before <[MG]> B>/, 500);
        # Output: 2 links with 500MB each
}

