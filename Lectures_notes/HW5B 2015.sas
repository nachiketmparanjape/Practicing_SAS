
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


data carot7; set carot6;
 acbcdiff = ac-bc;
 label acbcdiff='Difference in AC and BC Micellization';
run;

*  Step 2;

axis1 label = ('Percent Micellization for Alpha Carotein');
axis2 label = ('Percent Micellization for Beta Carotein');


proc gplot data=carot7;
  title 'Percent micellization for alpha-carotein, beta-carotein, and lutein (bubble size)';
  footnote j=r 'Data from Ashley Hart';
  bubble ac*bc = lutein / bcolor = green vaxis = axis1 haxis = axis2 bsize = 15;
run;


* Step 3;

symbol1 i=rlclm c = black co=red v = circle;

proc gplot data=carot7;
  title 'Prediction line for percent micellization of beta carotein vs alpha carotein';
  plot bc*ac / haxis = axis2 vaxis = axis1;
run;



* Step 4;

pattern1 v=s c=red;
pattern2 v=s c=green;
pattern3 v=s c=blue;

proc gchart data=carot7;
  title 'Mean Lutein Percent Micellization by Fiber and Level';
  block fiber / group = level patternid = group sumvar = lutein type = mean;
run;
