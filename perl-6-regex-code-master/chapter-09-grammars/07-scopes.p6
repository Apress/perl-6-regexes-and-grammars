grammar VariableLists {
    token TOP {
        :my %*SYMBOLS;
        <statement>*
    }
    token ws { <!ww> \h* }
    token statement {
        | <declaration>
        |  <block>
    }
    rule declaration {
        <identifier>
        { %*SYMBOLS{ $<identifier> } = True; }
        '=' <termlist>
        \n
    }
    rule block {
        :my %*SYMBOLS = CALLERS::<%*SYMBOLS>;
        '{' \n*
            <statement>*
        '}' \n*
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

say ? VariableLists.parse(q:to/EOF/);
a = 1
b = 2
{
    c = a, 5, b
}
EOF
