
* Step 1;

PROC IMPORT DBMS = excel DATAFILE = 'u:\STAT 6740\Data\Carotenoid Data.xlsx' OUT = carot REPLACE;
  SHEET="Sheet1";
  GETNAMES = yes;
  MIXED = yes;
RUN;

data carot2; set carot;
  if fiber = '' then delete;
  if food = '' then food = 'No food';
run;

* Step 2;

data carot3; set carot2;
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  rep = 6; conc = rep6; output;
  rep = 7; conc = rep7; output;
  rep = 8; conc = rep8; output;
  rep = 9; conc = rep9; output;
  rep = 10; conc = rep10; output;
  rep = 11; conc = rep11; output;

  if conc = . then delete;
run;

* Step 3;

data carot4; set carot3;
  if carotenoid = 'AC' then ac = conc;
  if carotenoid = 'BC' then bc = conc;
  if carotenoid = 'lutein' then lt = conc;
run;

proc sort data=carot4; by fiber level food enzyme rep; run;

proc means noprint data=carot4;
  by fiber level food enzyme rep;
  var ac bc lt;
  output out=carot5 max = ;
run;

data carot5; set carot5;
  if ac ne .;
run;

proc print data=carot5; run;

*Steps 4;

proc sort data= carot2; by fiber level food enzyme; run;

proc transpose data=carot2 out=carot6;
  by fiber level food enzyme;
  var rep1 - rep11;
  id carotenoid;
run;

data carot6; set carot6;
  where ac ~= .;
run;

proc print data = carot6; run;


* Step 5; 


data carot6; set carot6;
  if food = 'ripe banana' then food = 'Ripe banana';
run;

proc plot data=carot6;
  plot ac*(bc lutein) = food;
  plot bc*lutein = food;
run;


* Step 6;

proc chart data=carot6;
  vbar fiber;
run;


* Step 7;

proc sort data=carot6; by enzyme; run;

proc means mean min max std n data=carot6;
  by enzyme;
  var ac bc lutein;
run;
