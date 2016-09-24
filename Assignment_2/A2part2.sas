*Import carotenoid data from xls;
proc import DBMS = xls replace out=carot datafile='/folders/myfolders/Assignment_2/Carotenoid Data.xls';
	sheet = 'Sheet1';
	getnames=yes;
	mixed=yes;
run;

*Replace blacks by the phrase 'No food' wherever applicable;
*Delete the rows where no fiber data is available;
data carot; set carot;
	if fiber = '' then delete;
	if food = '' then food = 'No food';
run;

*Sort the data by food, then by fiber and finally by level;
proc sort data=carot; by food fiber level; run;

*Create a new column - fiber_food which contains fiber and food data in the format fiber - food;
data carot; set carot;
fiber_food = trim(fiber) || ' - ' || trim(food);
run;

*Defined a 'ranpm' that represents a random replicate using a random uniform number generator;
data carot; set carot;
	seed = 3464767345647;
	rannum = ranuni(seed);
	if rannum < 0.5 then ranpm = rep1;
	else if rannum < 0.8 then ranpm = rep2;
	else ranpm = rep3;
run;

proc print data=carot; where fiber_food = 'Control - raw banana'; var fiber_food rep1-rep11; run;

proc print data=carot; where ranpm = rep3; run;

*Output a separate dataset for each carotenoid;
libname sd '/folders/myfolders/Assignment_2';

data sd.ac sd.bc sd.lutein; set carot;
	if carotenoid = 'AC' then output sd.ac;
	else if carotenoid = 'BC' then output sd.bc;
	else output sd.lutein;
run;