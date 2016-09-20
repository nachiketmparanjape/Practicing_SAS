
libname saved 'e:\STAT 6740\Data library\';


%macro readsort;

%do i = 1 %to 4;

data model&i; set saved.modelvars&i; run;
proc sort data=model&i; by geo_id2; run;

%end;

%mend readsort;

%readsort;


data model_all;
  merge model1 model2 model3 model4;
  by geo_id2;
run;

proc contents data=model_all; run;

ods trace on;

proc univariate normal plot data=model_all;
  var num_pop;
run;

ods trace off;

proc univariate normal plot data=model_all;
  ods select moments testsfornormality;
  var num_pop;
run;

proc univariate normal plot data=model_all;
  ods exclude plots;
  var num_pop;
run;

proc univariate normal plot data=model_all;
  var num_pop;
  ods output testsfornormality=normaltest;
run;

proc print data=normaltest; run;


ods show;


