class VariableCollection {
    has %.definitions;

    method TOP($/) {
        %.definitions{ $<identifier> } = $<termlist>.made;
    }
    method number($/)     { make $/.Int }
    method identifier($/) { make $/.Str }
    method termlist($/)   { make $<term>».made }
    method term($/)       { make $/.values[0].made }
}

grammar VariableAssignment {
    rule  TOP        { \s* <identifier> '=' <termlist> }
    rule  termlist   { <term> * % ',' }
    token term       { <identifier> | <number> }
    token number     { \d+ }
    token identifier { <:alpha> \w* }
    token ws         { <!ww> \h* }
}


my $actions = VariableCollection.new;

my @lines = 'a = 1', 'c = a, 5, b', 'b = 2';

for @lines -> $line {
    unless VariableAssignment.parse($line, :$actions) {
        die qq[Invalid input: "$line"];
    }
}
say $actions.definitions;
        # Output: {a => [1], b => [2], c => [a 5 b]}
