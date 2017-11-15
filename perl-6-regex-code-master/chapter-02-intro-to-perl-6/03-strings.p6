my $name = 'Larry';
say "Hello, $name";             # Output: Hello, Larry
say 'Hello, $name';             # Output: Hello, $name

say 'a quote: \' a backslash: \\';
    # Output: a quote: ' a backslash: \

my $macbeth = q:to/END/;    # need to put the ; on this line!
When shall we three meet again?
In thunder, lightning, or in rain?
    When the hurlyburly's done,
    When the battle's lost and won.
END

print $macbeth;
