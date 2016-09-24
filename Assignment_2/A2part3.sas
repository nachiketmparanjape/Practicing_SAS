* Import datasets;
libname saved '/folders/myfolders/Assignment_2/';

data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

*Merging the datasets;

proc sort data=model1; by geo_id2; run;
proc sort data=model2; by geo_id2; run;
proc sort data=model3; by geo_id2; run;
proc sort data=model4; by geo_id2; run;

data allmodel; merge model1 - model4; by geo_id2;

data allmodel; set allmodel;
	statefips = floor(geo_id2/1000000000);
  	countyfips = floor((geo_id2 - 39000000000)/ 1000000);
  	tract = geo_id2 - 39049000000;
run;

*Create permanent SAS dataset;
libname sd '/folders/myfolders/Assignment_2/';

data sd.one; set allmodel;
	keep statefips countyfips tract pct_black pct_hs_ed pct_unemploy pct_vacant;
run;

* Import a permenent dataset and combine it with model4;
data frankdel; set model4 sd.delaware4; run;

proc export data=frankdel outfile='/folders/myfolders/Assignment_2/frankdel.dta' dbms=dta;
run;
