
filename sf 'F:\STAT 6740\SFRAD.dat';

data rad1;
  infile sf;
  input samp_id $ station $ rad $ cs ra ur;
run;

proc print data=rad1; run;




data rad1;
  infile 'F:\STAT 7640\SFRAD.dat';
  input samp_id $ station $ rad $ cs ra ur;
run;

proc print data=rad1; run;

filename sf 'e:\STAT 6740\SFRAD.dat';
