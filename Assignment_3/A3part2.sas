* Import data and basic cleaning;

proc import dbms=xls datafile='/folders/myfolders/Assignment_1/Carotenoid Data.xls' out=carot replace;
	sheet='Sheet1';
	getnames=yes;
	mixed=yes;
run;

data carot; set carot;
	if fiber = '' then delete;
	if food = '' then food = 'No Food';
run;

* Create a new dataset with new obeservation;
data carot2; set carot;
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
run;

data carot2; set carot2;
	if conc = . then delete;
	*drop rep1-rep11;
	keep Fiber Level Food Enzyme Carotenoid rep conc;
run;
	
data carot3; set carot2;
  if carotenoid = 'AC' then ac = conc;
  else if carotenoid = 'BC' then bc = conc;
  else lt = conc;
run;

proc sort data=carot3; by fiber level food enzyme rep; run;

proc means noprint data=carot3;
  by fiber level food enzyme rep;
  var ac bc lt;
  output out=carot4 max=;
run;

/* data carot4; set carot4; */
/*   if ac ne .; */
/* run; */

/* proc print data=carot4; run; */

*Use transpose;

proc sort data= carot; by fiber level food enzyme; run;

proc transpose data=carot out=carot4;
	by fiber level food enzyme;
	var rep1-rep11;
	id carotenoid;
run;

data carot4; set carot4;
  where ac ~= .;
run;

proc print data = carot4; run;

*Scatterplot for every pair of carotenoid;

proc plot data=carot4;
	PLOT ac*(bc lutein) = food;
	PLOT bc*lutein = food;
run;

*Bar plot;
proc chart data=carot4;
	vbar fiber;
run;

*Summary for each enzyme for each carotenoid;
proc sort data = carot4; by enzyme;

proc means mean min max std n data= carot4;
	by enzyme;
run;