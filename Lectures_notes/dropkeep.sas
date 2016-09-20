
libname leslie SPSS "e:\STAT 6740\LW.por";

data modelout; set leslie._first_; run;

proc contents data=modelout; run;

data model2; set modelout; 
  keep varname_ p1 - p10;
run;

proc print data=model2; run;

data model3; set modelout (keep=varname_ p1 - p10); run;

proc print data=model3; run;

data model4; set modelout; 
  drop rowtype_ p11 - p64;
run;

proc print data=model4; run;

data model5; set modelout (drop=rowtype_ p11 - p64); run;

proc print data=model5; run;

data model6 (keep=varname_ p1 - p10); set modelout; run;

proc print data=model6; run;

data model7 (drop=rowtype_ p11 - p64); set modelout; run;

proc print data=model7; run;
