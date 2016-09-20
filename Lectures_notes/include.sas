

%let datalib='e:\STAT 6740\Data library\';   *subdirectory for your existing dataset;
%let datain=CDCTest;     *the name of your existing SAS dataset;
%let dataout=GrowthTest;    *the name of the dataset you wish to put the results into;
%let saspgm='e:\STAT 6740\gc-calculate-BIV.sas'; *subdirectory for the downloaded program gc-calculate-BIV.sas;

Libname mydata &datalib;

proc print data=mydata.&datain; run;

data _INDATA; set mydata.&datain;

%include &saspgm;

data mydata.&dataout; set _INDATA;

proc means;

run;

proc print data=_INDATA; run;

proc contents data=_INDATA;
 run;

 
proc export data=mydata.&dataout
			outfile = 'e:\STAT 6740\cdcgrowth.csv' 
			dbms=csv;
run;
