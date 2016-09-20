
*Step 1;

libname saved 'u:\STAT 6740\Data library\';

data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

proc sort data=model1; by geo_id2; run;
proc sort data=model2; by geo_id2; run;
proc sort data=model3; by geo_id2; run;
proc sort data=model4; by geo_id2; run;

data allmodel;
  merge model1 - model4; by geo_id2;
run;

* Step 2;

proc univariate normal plot data=allmodel;
  var pct_black pct_f_head pct_unemploy pct_pre_50;
run;


* Step 3;

proc plot data=allmodel;
  plot pct_black*(pct_f_head pct_unemploy pct_pre_50);
  plot pct_f_head*(pct_unemploy pct_pre_50);
  plot pct_unemploy*pct_pre_50;
run;


* Steps 4 & 5;

data allmodel2; set allmodel;
  if pct_black > 75 then ibr = 1; else ibr = 0;
  if pct_f_head > 25 then ifr = 1; else ifr = 0;
  if pct_unemploy > 20 then iur = 1; else iur = 0;
  if pct_pre_50 > 33 then iar = 1; else iar = 0;

  num_rf = sum(ibr, ifr, iur, iar);
run;


proc freq data=allmodel2;
  tables ibr ifr iur iar;
run;

proc freq data=allmodel2;
  tables ibr*(ifr iur iar);
  tables ifr*(iur iar);
  tables iur*iar;
run;

proc freq data=allmodel2;
  table num_rf;
run;

proc print data=allmodel2;
  where num_rf > 2;
run;

