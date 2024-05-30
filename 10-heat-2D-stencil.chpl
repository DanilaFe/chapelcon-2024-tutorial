use StencilDist;
use ImageUtils;

config const nx, ny = 1000;
config const N = 10000;
const alpha = 0.1;

const omega = stencilDist.createDomain(0..<nx, 0..<ny),
      omegaHat = omega.expand(-1);

var u: [omega] real = 1.0;
u[nx/4..nx/2, ny/4..ny/2] = 2.0;
var un = u;

writeImage(u);

for 1..N {
  un <=> u;
  forall (i, j) in omegaHat do
    u[i, j] = un[i, j] + alpha * (
	       un[i-1, j] + un[i, j-1] +
	       un[i+1, j] + un[i, j+1] -
	       4 * un[i, j]);
  writeImage(u);
}
