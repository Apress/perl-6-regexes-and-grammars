for 2..15 -> $number {
	my $encoded = 'a' x $number;
	if $encoded ~~ / ^ (a ** 2..*) $0+ $ / {
	    say "$number is not a prime, a factor is ",  $0.chars;
	}
	else {
	    say "$number is a prime";
	}
}
