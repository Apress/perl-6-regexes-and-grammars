class Point {
    has $.x;
    has $.y;
    method magnitude() {
        return sqrt($.x * $.x + $.y * $.y);
    }
}
my $p = Point.new( x => 5, y => 2 );
say $p.x;                           # Output: 5
say $p.magnitude();                 # Output: 5.3851648071345
