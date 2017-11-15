for 1, 2, 3 {
    say $_;
}
if 1 > 2 {
    say "No Way";
}
elsif 1 == 2 {
    say "Still no chance";
}
else {
    say "This runs";
}


for 1, 2, 3 -> $value {
    say $value;
}

my $callback = -> $x, $y { $x + $y };
say $callback(1, 2);                    # Output: 3
