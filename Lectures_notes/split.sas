
PROC IMPORT OUT=campbell
            FILE="e:\STAT 6740\joes.dta"
            DBMS=STATA REPLACE;
RUN;

data south1 south0 southmiss; set campbell;
  if southr = 1 then output south1;
  else if southr = 0 then output south0;
  else output southmiss;
run;

data s0 s1; set campbell;
  if southr = 1 then output s1;
  if southr ne . then output s0;
run;
