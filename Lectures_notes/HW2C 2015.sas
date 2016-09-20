
*Step 1;

libname saved 'e:\STAT 6740\Data library\';

data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

*Step 2;

proc contents data=model1; run;
proc contents data=model2; run;
proc contents data=model3; run;
proc contents data=model4; run;

*Step 3;

proc sort data=model1; by geo_id2; run;
proc sort data=model2; by geo_id2; run;
proc sort data=model3; by geo_id2; run;
proc sort data=model4; by geo_id2; run;

data allmodel;
  merge model1 - model4; by geo_id2;
run;

* Step 4;

data allmodel2; set allmodel;
  statefips = floor(geo_id2/1000000000);
  countyfips = floor((geo_id2 - 39000000000)/ 1000000);
  tract = geo_id2 - 39049000000;
run;

*Step 5;

data allmodel3; set allmodel2;
  rat_hisp_unem = pct_hisp / pct_unemploy;
  pct_hs_only = pct_hs_ed - pct_cl_ed;
  num_vac = round(num_house*pct_vacant/100,1);
  num_pre_50 = round(num_house*pct_pre_50/100,1);
run;

* Step 6;

proc print data=allmodel3;
  where tract > 10000;
run;

proc print data=allmodel3;
  where pct_vacant < 5;
run;

proc print data=allmodel3;
  where pct_married < 10;
run;

proc print data=allmodel3;
  where pct_asian > pct_mixed;
run;

*Step 7;

libname dl 'e:\STAT 6740\Data Library';

data dl.one; set allmodel3;
  keep statefips countyfips tract pct_black pct_hs_ed pct_unemploy pct_vacant;
run;

data frankdel;
  set model4 dl.delaware4;
run;

* Step 9;

proc export data=frankdel outfile = 'e:\STAT 6740\Data Library\frankdel.dta' dbms = dta;
run;
