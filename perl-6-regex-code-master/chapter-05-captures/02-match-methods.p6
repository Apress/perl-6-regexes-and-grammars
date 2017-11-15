my $input = "There are 9 million bicycles in Beijing";
if $input ~~ /(\d+) \s+ (\w+)/ {
    say $0.^name;       # Output: Match
    say $1;             # Output: ⌜million⌟
    say $1.from;        # Output: 12
    say $1.to;          # Output: 19
}
