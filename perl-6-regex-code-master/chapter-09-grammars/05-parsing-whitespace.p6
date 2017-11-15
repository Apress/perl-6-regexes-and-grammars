grammar INIFile {
    token TOP { <section>* }
    token section {
        <header>
        <keyvalue>*
    }
    rule header {
        '['  <-[ \] \n ]>+ ']' <.eol>
    }
    rule keyvalue {
        ^^
        $<key>=[\w+]
        <[:=]>
        $<value>=[<-[\n;#]>*]
        <.eol>
    }
    token ws { <!ww> \h* }
    token eol {
        \n [\h*\n]*
    }
}

my $input = q:to/EOF/;
[db]
driver: mysql
host: db01.example.com
port: 122
username: us123
password: s3kr1t
EOF

say INIFile.parse($input);
