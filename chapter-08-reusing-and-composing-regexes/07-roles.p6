role ParseInteger {
    token unsigned { <[0..9]>+ }
    token signed   { ['+' | '-']? <unsigned> }
}

role ParseFloat does ParseInteger {
    token escale { <[eE]> <unsigned> }
    token float {
        $<sign>=<[+-]>?
        [
          $<coeff> = [ <[0..9]>* '.' <unsigned> ] <escale>?
        | $<coeff> = [               <unsigned> ] <escale>
        ]
    }
}

grammar Sum does ParseFloat {
    token number { <signed> | <float> }
    rule TOP { <number> '+' <number> }
}
grammar JSON does ParseFloat {
    token value {
           <signed>
         | <float>
           # more options go here
    }
    # rest of the grammar here
}

say Sum.parse('2 + -4');

