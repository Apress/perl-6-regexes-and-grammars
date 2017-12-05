grammar StandardSQL {
    regex TOP {
        'SELECT' \s+ <name>
    }
    regex name {
         <identifier>
        | <quoted_name>
    }
    regex quoted_name {
        \" <-["]>+ \"
    }
    regex identifier {
        « <:alpha> \w* »
    }
}

say StandardSQL.parse('SELECT salary');
say StandardSQL.parse('SELECT "monthly salary"');


grammar MysqlSQL is StandardSQL {
    regex quoted_name {
        \` <-[`]>+ \`
    }
}
say MysqlSQL.parse('SELECT `monthly salary`');

