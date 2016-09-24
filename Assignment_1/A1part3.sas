libname saved '/folders/myfolders/Assignment_1/';

data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

proc contents data=model1; run;
proc contents data=model2; run;
proc contents data=model3; run;
proc contents data=model4; run;