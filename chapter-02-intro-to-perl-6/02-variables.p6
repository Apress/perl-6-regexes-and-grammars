my $x = 1;
my @capitals = 'Algiers', 'Tirana', 'Berlin', 'Tokio';
my %populations =
    Algiers => 3_500_000,
    Berlin  => 3_700_000,
    Tirana  => 353_400,
    ;

say %populations{'Algiers'};  # Output: 3500000
say %populations.keys.sort;   # Output: (Algiers Berlin Tirana)
say %populations.values.sum;  # Output: 7553400

