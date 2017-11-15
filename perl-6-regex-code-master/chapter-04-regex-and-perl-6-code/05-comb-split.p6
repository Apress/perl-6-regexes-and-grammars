my @numbers = "1308 5th Avenue".comb(/\d+/);
say @numbers;       # Output: [1308 5]

my ($city, $area, $popul) = 'Berlin;891.8;3671000'.split(/';'/);
say $area;          # Output: 891.8

{
    my ($city, $rest) = 'Berlin;891.8;3671000'.split(';', 2);
    say $city;          # Output: Berlin
    say $rest;          # Output: 891.8;3671000
}
