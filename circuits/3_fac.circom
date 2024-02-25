pragma circom 2.1.5 ;

template Multiplier () {
  signal input a ;
  signal input b ;
  signal output c ;
  c <== a * b ;
}

template three_fac () {
  signal input x1 ;
  signal input x2 ;
  signal input x3 ;
  signal output x4 ;
  component mult1 = Multiplier() ;
  component mult2 = Multiplier() ;
  mult1.a <== x1 ;
  mult1.b <== x2 ;
  mult2.a <== mult1.c ;
  mult2.b <== x3 ;
  x4 <== mult2.c ;
}

component main {public [x1]} = three_fac() ;