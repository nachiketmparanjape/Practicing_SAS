
PROC IMPORT OUT=campbell
            FILE="e:\STAT 6740\joes.dta"
            DBMS=STATA REPLACE;
RUN;

PROC CONTENTS DATA=campbell; RUN;
