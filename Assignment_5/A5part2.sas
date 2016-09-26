* Import data;
proc import dbms=xls datafile="/folders/myfolders/Assignment_1/Carotenoid Data.xls" out=carot replace;
	sheet='Sheet1';
	getnames=yes;
	mixed=yes;
	run;

data carot2; set carot;
	if fiber = '' then delete;
	if food = '' then food = 'No food';
run;

*transpose;
proc sort data=carot2; by fiber level food enzyme; run;

proc transpose data=carot2 out = carot6;
	by fiber level food enzyme;
	var rep1 - rep11;
	id carotenoid;
run;

data carot6; set carot6;
	where ac ne .;
run;

*Add acdcdiff column;
data carot7; set carot6;
	acbcdiff = ac - bc;
	label 	acbcdiff='Difference in AC and BC Micellization'
			Fiber = 'Test Fiber'
  			Level = 'Fiber Level'
			Food = 'Test Food'
			Enzyme = 'Enzyme Strength'
			lutein = 'Lutein Pct Micellization'
			ac = 'Alpha Carotein Pct Micellization'
			bc = 'Beta Carotein Pct Micellization';
	if food = 'ripe banana' then food = 'Ripe banana';
run;

* Bubble Chart;

proc sgplot data=carot7;
	title 'Percent micellization for alpha-carotein, beta-carotein, and lutein (bubble size)';
  	footnote j=r 'Data from Ashley Hart';
  	bubble x = ac y = bc size = lutein / bradiusmax=15;
  	xaxis label= 'Percent Micellization for Alpha Carotein';
  	yaxis label= 'Percent Micellization for Beta Carotein';
run;

*Linear Regression;

proc sgplot data=carot7;
	title 'Prediction line for percent micellization of beta carotein vs alpha carotein';
	reg y=bc x=ac;
   	inset "Intercept = &Int" "Slope = &Slope" / 
         border title="Parameter Estimates" position=topleft;
run;

*Block Chart;
proc chart data=carot7;
	title 'Mean Lutein Percent Micellization by Fiber and Level';
  	block fiber / group = level sumvar = lutein type = mean;
run;