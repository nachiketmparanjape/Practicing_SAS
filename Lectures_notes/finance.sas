
PROC IMPORT OUT=campbell
            FILE="e:\STAT 6740\joes.dta"
            DBMS=STATA REPLACE;
RUN;

data campbell; set campbell;
  cum_int_pmt = cumipmt(0.05, 4, revcap, 1, 4, 0);
run;

proc print data=campbell;
  where cum_int_pmt > 250;
  var stcofips areaname pop05 revcap cum_int_pmt;
run;
