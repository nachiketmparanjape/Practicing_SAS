*Import Data;
proc import dbms=xls datafile="/folders/myfolders/Assignment_1/Carotenoid Data.xls" out=carot replace;
	sheet='Sheet1';
	getnames=yes;
	mixed=yes;
run;

data carot2; set carot;
	if fiber = '' then delete;
	if food = '' then food = 'No food';
run;

*Create new observation for each repetition and new variables for each carotenoid;
proc sort data= carot2; by fiber level food enzyme; run;

proc transpose data= carot2 out=carot6;
	by fiber level food enzyme;
	var rep1 - rep11;
	id carotenoid;
run;

data carot6; set carot6;
  where ac ~= .;
run;

*Labelling;
data carot6; set carot6;
	if food = 'raw banana' then food = 'Raw banana';
	label 	Fiber = 'Test Fiber'
  			Level = 'Fiber Level'
			Food = 'Test Food'
			Enzyme = 'Enzyme Strength'
			lutein = 'Lutein Pct Micellization'
			ac = 'Alpha Carotein Pct Micellization'
			bc = 'Beta Carotein Pct Micellization';
run;

*Tabulate summary statistics for each combination of fiber, level enzyme strength and carotenoid;
proc tabulate data=carot6;
	title "Summary Statistics for Percent Micellization";
	footnote j=l "Data from Ashley Hart";
	class fiber level enzyme;
	var lutein ac bc;
	table fiber*level*enzyme, (ac bc lutein) * (n='Number of sample' mean = 'Mean Pct Micel' std = 'Std Dev Pct Micel' p90 = '90th Percentile Pct Micel');;
run;

*Create new variable for difference between AC and BC;
data carot7; set carot6;
	acbcdiff = ac - bc;
	label acbcdiff='Difference between AC and BC';
run;

*Differences and T-test results using tabulate;
proc tabulate data=carot7;
  	title 'Test Results Comparing AC and BC Micellization';
  	class fiber level food enzyme;
  	var acbcdiff;
  	table fiber*level*food*enzyme,acbcdiff*(t='T statistic' probt='p-value');
run;