grammar VariableLists {
    token TOP {
        :my %*SYMBOLS;
        <statement>*
    }
    token ws { <!ww> \h* }
    rule statement {
        <identifier>
        { %*SYMBOLS{ $<identifier> } = True }
        '=' <termlist>
        \n
    }
    rule termlist { <term> * % ',' }
    token term { <variable> | <number> }
    token variable {
        <identifier>
        <?{ %*SYMBOLS{ $<identifier> } }>
    }
    token number { \d+ }
    token identifier { <:alpha> \w* }
}

my $correct-order = q:to/EOF/;
a = 1
b = 2
c = a, 5, b
EOF

say ? VariableLists.parse($correct-order);

my $wrong-order = q:to/EOF/;
a = 1
c = a, 5, b
b = 2
EOF

say ? VariableLists.parse($wrong-order);
