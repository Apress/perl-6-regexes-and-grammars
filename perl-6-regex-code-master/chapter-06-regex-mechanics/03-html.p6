my $html-re = rx:ignorecase{
    '<' $<tag>=[ <[a..z]>+ ] # opening tag
         <-[ > ]>*           # attributes within opening tag
    '>'
        ( .* )               # content between opening and closing tags
    '</' $<tag> '>'          # closing tag
};

say 'more text <a href="..:">link text</a> bla' ~~ $html-re;

