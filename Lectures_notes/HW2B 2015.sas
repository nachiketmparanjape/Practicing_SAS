
* Step 1;

PROC IMPORT DBMS = xlsx DATAFILE = 'e:\STAT 6740\Carotenoid Data.xlsx' OUT = carot REPLACE;
  SHEET="Sheet1";
  GETNAMES = yes;
  MIXED = yes;
RUN;

* Step 2;

data carot2; set carot;
  if fiber = '' then delete;
  if food = '' then food = 'No food';
run;

* Step 3;

proc sort data=carot2;  by food fiber level; run;

*Step 4;

data carot3; set carot2;
  fiber_food = fiber || '- ' || food;
run;


*Steps 5 & 6;

data carot4; set carot3;
  seed = 314159265;
  rannum = ranuni(seed);
  if rannum < 0.5 then ranrep = 1;
  else if rannum < 0.8 then ranrep = 2;
  else ranrep = 3;

  if ranrep = 1 then ranpm = rep1;
  else if ranrep = 2 then ranpm = rep2;
  else ranpm = rep3;
run;

*Step 7;

proc print data=carot4;
  where fiber_food = 'Control- raw banana';
  var rep1 - rep11;
run;

proc print data=carot4;
  where ranrep = 3;
run;

proc print data=carot4;
  where ranpm < 25;
run;

proc print data=carot4;
  where food = 'No food' & rep1 < ranpm;
run;

* Step 8;

libname sd 'e:\STAT 6740\Data Library';

data sd.ac sd.bc sd.lutein; set carot4;
  if carotenoid = 'AC' then output sd.ac;
  else if carotenoid = 'BC' then output sd.bc;
  else output sd.lutein;
run;
