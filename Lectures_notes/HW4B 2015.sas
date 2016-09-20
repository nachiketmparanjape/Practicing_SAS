
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


proc sort data= carot2; by fiber level food enzyme; run;

proc transpose data=carot2 out=carot6;
  by fiber level food enzyme;
  var rep1 - rep11;
  id carotenoid;
run;

data carot6; set carot6;
  where ac ~= .;
run;


* Step 2; 

data carot6; set carot6;
  if food = 'ripe banana' then food = 'Ripe banana';
  label Fiber = 'Test Fiber'
  		Level = 'Fiber Level'
		Food = 'Test Food'
		Enzyme = 'Enzyme Strength'
		lutein = 'Lutein Pct Micellization'
		ac = 'Alpha Carotein Pct Micellization'
		bc = 'Beta Carotein Pct Micellization';
run;

* Step 3;

proc tabulate data=carot6;
  title 'Summary Statistics for Percent Micellization';
  footnote j=l 'Data from Ashley Hart';
  class fiber level enzyme;
  var lutein ac bc;
  table fiber*level*enzyme,(ac bc lutein)*(n='Number of sample' mean = 'Mean Pct Micel' std = 'Std Dev Pct Micel' p90 = '90th Percentile Pct Micel');
run;


* Step 4;

data carot7; set carot6;
 acbcdiff = ac-bc;
 label acbcdiff='Difference in AC and BC Micellization';
run;

proc tabulate data=carot7;
  title 'Test Results Comparing AC and BC Micellization';
  class fiber level food enzyme;
  var acbcdiff;
  table fiber*level*food*enzyme,acbcdiff*(t='T statistic' probt='p-value');
run;
