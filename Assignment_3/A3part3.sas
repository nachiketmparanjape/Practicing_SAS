*Import Data;

libname saved "/folders/myfolders/Assignment_2/";

data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

proc sort data=model1; by geo_id2; run;
proc sort data=model2; by geo_id2; run;
proc sort data=model3; by geo_id2; run;
proc sort data=model4; by geo_id2; run;

*Merge;
data allmodels;
	merge model1 - model4; by geo_id2;
run;

*Summary Statistics;
proc univariate data= allmodels;
	var pct_black pct_f_head pct_unemploy pct_pre_50;
run;

*Scatterplot for 4 variables associated with risk - pct_black pct_f_head pct_unemploy pct_pre_50;

proc plot data = allmodels;
	plot pct_black*(pct_f_head pct_unemploy pct_pre_50);
	plot pct_f_head*(pct_unemploy pct_pre_50);
	plot pct_unemploy * pct_pre_50;
run;

* Define variables as per the given criteria for risk;
data allmodel2; set allmodels;
	if pct_black > 75 then ibr = 1; else ibr = 0;
  	if pct_f_head > 25 then ifr = 1; else ifr = 0;
  	if pct_unemploy > 20 then iur = 1; else iur = 0;
  	if pct_pre_50 > 33 then iar = 1; else iar = 0;

  num_rf = sum(ibr, ifr, iur, iar);
run;

*Print frequency tables for the variables associated with risk;
proc freq data=allmodel2;
	tables ibr ifr iur iar num_rf;
run;

*Print cross-tabulation for each pair of risk factors;
proc freq data=allmodel2;
	tables ibr*(ifr iur iar);
	tables ifr* (iur iar);
	tables iur* iar;

*Print the data where there are 3 or more valid risk factors;	
proc print data=allmodel2;
 where num_rf > 2;
run;

