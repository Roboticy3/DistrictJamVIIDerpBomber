setcps(1);

p1: note("<0 -> * 16").
  sound("supersaw").
  lpf(sine.range(1500, 2500).slow(4))