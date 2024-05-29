var x = 10;


on here.gpus[0] {
  var A = [1, 2, 3, 4, 5 ];
  forall a in A do a += 1;
}

writeln(x);
