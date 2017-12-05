class Identifier { has $.str }

class S-Actions {
    method TOP($/)                  { make $<expression>».made     }
    method expression($/)           { make $<atom>».made           }
    method atom:sym<expression>($/) { make $<expression>.made      }
    method atom:sym<identifier>($/) {
        make Identifier.new(str => $/.Str);
    }
    method atom:sym<integer>($/)    { make $/.Int                  }
    method atom:sym<string>($/)     { make $<string_contents>.made }
    method string_contents($/) {
        make $/.Str.subst(:global, / \\ (.) /, -> $/ { $0 })
    }
}

grammar S-Expression {
    token TOP                  { \s* <expression>+ %% \s*    }
    token expression           {
        \s* '(' ~ ')' [\s* <atom>* % \s+ \s*]
    }
    proto token atom {*}
    token atom:sym<expression> { <expression>                }
    token atom:sym<identifier> {
        <[ a..z A..Z =*:+- ]>
        <[ a..z A..Z 0..9 _ =*:+- ]>*
    }
    token atom:sym<integer>    { <[+-]>? <[0..9]>+           }
    token atom:sym<string>     { '"' ~ '"' <string_contents> }
    token string_contents      { [ | <-[\\"]>+ | \\ .  ]*    }
}

use Test;

my %atoms = 
    integer    => ('1', '01234', '-23', '+12'),
    identifier => ('abc', '=', '*_*'),
    string     => ('""', '"abc"', Q'"abc\"def"', Q'"\\"'),
    ;

my %not-atoms = 
    identifier  => ('', '_'),
    string      => ('', '"""', Q'"\"',),
    ;

for %atoms.keys.sort -> $atom {
    for %atoms{$atom}.list -> $test {
        ok S-Expression.parse($test, rule => "atom:sym<$atom>"),
            "Parsing '$test' as atom $atom";
    }
}

for %not-atoms.keys.sort -> $atom {
    for %not-atoms{$atom}.list -> $test {
        nok try {S-Expression.parse($test,
                rule => "atom:sym<$atom>") },
            "Not parsing '$test' as atom $atom";
    }
}

my @tests = '()', '(abc)', ' (abc) ', '( abc )',
            '(1)', '(+1)', '(-1)', '( () ( ) )',
            Q:to/EOF/;
(define factorial
  (lambda (n)
    (if (= n 0)
      1
      (* n (factorial (- n 1))))))
EOF

for @tests -> $t {
    ok S-Expression.parse($t), "can parse '$t'";
}

my $m = S-Expression.parse(
    Q'((a "b") 23 "ab \\cd")',
    actions => S-Actions.new,
);
ok $m, 'Can parse S-Expression with action method';

is-deeply $m.made,
    [[[Identifier.new(str => "a"), "b"], 23, "ab \\cd"],],
    "correct data extracted";

sub parse-s-expression(Str $input) {
    my $m = S-Expression.parse($input, actions => S-Actions.new);
    unless $m {
        die "Cannot parse S-Expression";
    }
    return $m.made;
}

say parse-s-expression('(a) (2)').perl;

done-testing;
