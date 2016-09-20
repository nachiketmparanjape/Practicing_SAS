
libname leslie SPSS "e:\STAT 6740\LW.por";

data modelout; set leslie._first_; run;

proc contents data=modelout; run;

proc print data=modelout;
  where p3 = 0 & p9 = 0;
  var p4 - p12;
run;

proc import datafile='e:\STAT 6740\LW.sav'
			out = model2
			dbms = sav
			replace;
run;

proc contents data=model2; run;
