
filename sf 'e:\STAT 6740\SFRAD.dat';

data rad1;
  infile sf;
  input samp_id $ station $ rad $ cs ra ur;
run;

data rad2; set rad1;
  totrad = cs + ra + ur;
  sr_ra = sqrt(ra);
  exp_ur = exp(ur);
  pct_ur = 100*ur/totrad;
  mod_cs = floor(1000*cs);
  cos_cs = cos(cs);
  ac_cs = arcos(cs);
  ur_gt_cs = sign(ur-cs);
run;

proc print data=rad2; run;

