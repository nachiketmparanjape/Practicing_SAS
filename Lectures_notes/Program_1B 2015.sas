
PROC IMPORT DBMS = excel DATAFILE = 'u:\STAT 6740\Data\Carotenoid Data.xlsx' OUT = carot REPLACE;
  SHEET="Sheet1";
  GETNAMES = yes;
  MIXED = yes;
RUN;

proc contents data=carot; run;

data carot2; set carot;
  diff12 = rep1 - rep2;
  diff13 = rep1 - rep3;
  diff23 = rep2 - rep3;

  max_conc = max(of rep1 - rep11);
  if max_conc = rep1 then max_rep = 1;
  else if max_conc = rep2 then max_rep = 2;
  else if max_conc = rep3 then max_rep = 3;
  else if max_conc = rep4 then max_rep = 4;
  else if max_conc = rep5 then max_rep = 5;
  else if max_conc = rep6 then max_rep = 6;
  else if max_conc = rep7 then max_rep = 7;
  else if max_conc = rep8 then max_rep = 8;
  else if max_conc = rep9 then max_rep = 9;
  else if max_conc = rep10 then max_rep = 10;
  else max_rep = 11;
run;

proc print data=carot2;
  where fiber = 'Control';
  var fiber level food enzyme carotenoid;
run;

proc print data=carot2;
  where carotenoid = 'lutein' & enzyme = '1x';
  var fiber level food carotenoid rep1 - rep11 diff12 diff13 diff23 max_conc max_rep;
run;

proc print data=carot2;
  where fiber ~= 'Control';
  var fiber level food carotenoid diff12 diff13 diff23;
run;

proc print data=carot2;
  where max_rep > 3;
  var fiber level food carotenoid max_rep;
run;

proc print data=carot2;
  where fiber = 'GOS' & rep4 > 0;
run;

