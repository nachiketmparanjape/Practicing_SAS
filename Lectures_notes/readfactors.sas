
options mprint;

libname saved 'e:\STAT 6740\Data library\';

%let sv = geo_id2;

/*
data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

proc sort data=model1; by geo_id2; run;
proc sort data=model2; by geo_id2; run;
proc sort data=model3; by geo_id2; run;
proc sort data=model4; by geo_id2; run;
*/

%macro readsort;

%do i = 1 %to 4;

data model&i; set saved.modelvars&i; run;
proc sort data=model&i; by &sv; run;

%end;

%mend readsort;

%readsort;


data model_all;
  merge model1 model2 model3 model4;
  by &sv;
run;
