
proc import datafile = "e:\STAT 6740\ID_FIPS.CSV"
	dbms = csv out = countycode replace;
run;

proc print data=countycode; run;
