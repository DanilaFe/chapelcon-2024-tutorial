use BlockDist;
use ImageUtils;

config const nx = 100000;
config const N = 10000;
const alpha = 0.1;

const omega = blockDist.createDomain({0..<nx}),
      omegaHat = omega.expand(-1);

var u: [omega] real = 1.0;
u[nx/4..3*nx/4] = 2.0;
var un = u;

writeImage(u);

for 1..N {
  un <=> u;
  forall i in omegaHat do
    u[i] = un[i] + alpha *
	   (un[i-1] - 2*un[i] + un[i+1]);
  writeImage(u);
}
