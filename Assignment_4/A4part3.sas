*Import data;
libname sd "/folders/myfolders/Assignment_2/";

data model1; set sd.modelvars1; run;
data model2; set sd.modelvars2; run;
data model3; set sd.modelvars3; run;
data model4; set sd.modelvars4; run;

proc sort data=model1; by geo_id2; run;
proc sort data=model2; by geo_id2; run;
proc sort data=model3; by geo_id2; run;
proc sort data=model4; by geo_id2; run;

data allmodel;
	merge model1 model2 model3 model4; by geo_id2;
run;

*Set format for variables associated with risk;
proc format;
	value risk 0 = 'Low Risk' 1 = 'High Risk';
run;

data allmodel2; set allmodel;
	format ibr ifr iur iar risk.;
	
	if pct_black > 75 then ibr = 1; else ibr = 0;
  	if pct_f_head > 25 then ifr = 1; else ifr = 0;
  	if pct_unemploy > 20 then iur = 1; else iur = 0;
  	if pct_pre_50 > 33 then iar = 1; else iar = 0;

  	num_rf = sum(ibr, ifr, iur, iar);
  	
  	label 	ibr = 'Risk due to race'
  			ifr = 'Risk due to female head'
			iur = 'Risk due to unemployment'
			iar = 'Risk due to age of home';
run;

*Distribution of Risk Factors Across Census Tracts;
proc tabulate data=allmodel2;
	title 'Distribution of Risk Factors Across Census Tracts';
	footnote j=r 'Data from American Factfinder/U.S. Census Bureau';
	class ibr ifr iar iur;
	table (ibr all)*(ifr all),(iur all)*(iar all)*(n='Number of Census Tract' pctn = 'Percentage of Census Tracts');
run;

*Total People and Households Across Risk Factor Categories;
proc tabulate data=allmodel2 format=8. style=[color=red];
	title 'Total People and Households Across Risk Factor Categories';
	class ibr ifr iur iar / style=[color = green];
	var num_pop num_house / style=[color=blue];
	label num_pop = 'Total Population Count' num_house = 'Number of Households';
	table (ibr all)*(ifr all), (iur all)*(iar all)*(num_pop num_house)*sum='Total Count';
run;