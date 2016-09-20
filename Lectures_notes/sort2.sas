
PROC IMPORT OUT=campbell
            FILE="e:\STAT 6740\joes.dta"
            DBMS=STATA REPLACE;
RUN;

PROC CONTENTS DATA=campbell; RUN;

data campbell; set campbell;
  ob_id = _n_;
run;

proc sort data=campbell; by statcode; run;

proc print data=campbell;  where ob_id < 20; run;

proc sort data=campbell out=campbell2; by descending statcode; run;

proc print data=campbell2;  where ob_id < 20; run;

proc sort data=campbell2; by southr stcofips; run;

proc print data=campbell2;  where ob_id < 20; run;

proc sort data=campbell2 out=southstate nodupkey; by southr statcode; run;

proc print data=southstate; 
  var ob_id southr statcode pop05; run;
