*Import the excel file with the carotenoid data;
proc import DBMS = xls replace out=carot datafile='/folders/myfolders/Assignment_1/Carotenoid Data.xls';
	sheet="Sheet1";
	getnames=yes;
	mixed=yes;
run;

proc contents data=carot; run;

data carot2; set carot;
	diff12 = Rep1 - Rep2;
	diff23 = Rep2 - Rep3;
	diff13 = Rep1 - Rep3;
	
	max_conc = max(of Rep1 - Rep11);
	if max_conc = Rep1 then max_rep = 1;
	else if max_conc = Rep2 then max_rep = 2;
	else if max_conc = Rep3 then max_rep = 3;
	else if max_conc = Rep4 then max_rep = 4;
	else if max_conc = Rep5 then max_rep = 5;
	else if max_conc = Rep6 then max_rep = 6;
	else if max_conc = Rep7 then max_rep = 7;
	else if max_conc = Rep8 then max_rep = 8;
	else if max_conc = Rep9 then max_rep = 9;
	else if max_conc = Rep10 then max_rep = 10;
	else if max_conc = Rep11 then max_rep = 11;
run;

proc print data=carot2;
where Fiber='Control';
var Fiber Level Food Enzyme Carotenoid;
run;

proc print data=carot2;
where carotenoid = 'lutein' and enzyme = '1x';
var fiber level food carotenoid rep1 - rep11 diff12 diff13 diff23 max_conc max_rep;
run;

