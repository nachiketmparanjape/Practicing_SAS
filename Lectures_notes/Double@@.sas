
data test;
   input name $ age @@;
   datalines;
John 13 Monica 12 Sue 15 Steven 10
Marc 22 Lily 17
;
run;

proc print; run;
