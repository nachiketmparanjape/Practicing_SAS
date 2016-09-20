
PROC IMPORT OUT=campbell
            FILE="e:\STAT 6740\joes.dta"
            DBMS=STATA REPLACE;
RUN;

PROC CONTENTS DATA=campbell; RUN;

/*
proc freq data=campbell;
  table statcode southr civic05 pol05 size7a;
run;
*/

data north1; set campbell;
  if southr = 1 then delete;
run;

data north2; set campbell;
  if southr = 0;
run;

data civic_n; set campbell;
  if civic05 >= 50 & southr = 1;
run;

proc print data=civic_n; run;

data civ_pol; set campbell;
  if civic05 < 50 | pol05 < 20 then delete;
run;

proc print data=civ_pol; run;


data civic_n; set campbell (where = (civic05 >= 50 & southr = 1));
run;

proc print data=civic_n; run;
