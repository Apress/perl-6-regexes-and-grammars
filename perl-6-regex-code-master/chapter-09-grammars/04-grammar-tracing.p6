use Grammar::Tracer;

grammar INI {
    token TOP {
        ^ <.eol>* <toplevel>?  <sections>* <.eol>* $
            }
    token toplevel { <keyval>* }
    token sections { <header> <keyval>* }
    token header   { ^^ \h* '[' ~ ']' $<text>=<-[ \] \n ]>+
                     \h* <.eol>+ }
    token keyval   { ^^ \h* <key> \h* '=' \h* <value>? \h*
                     <.eol>+ }
    regex key      { <![#\[]> <-[;=]>+ }
    regex value    { [ <![#;]> \N ]+ }
    token eol      { [ <[#;]> \N* ]? \n }
}

INI.parse(q:to/EOF/);
a = b
[foo]
c: d
EOF
