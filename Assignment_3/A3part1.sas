* Import the datasets;
filename a1 "/folders/myfolders/files/aaup_dat.txt";

data salary;
	infile a1;
  	input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;

proc import dbms=csv out=usnews datafile="/folders/myfolders/files/usnews.csv" replace; run;

data usnews; set usnews;
  name2 = name;
  drop name;
run;

* Sort;
proc sort data=salary; by fice; run;
proc sort data=usnews; by fice; run;

* Merge datasets;
data salenroll;
	merge salary usnews; by fice;
	
	* Add region column;
	if state in ('CT', 'ME', 'MA', 'NH', 'RI', 'VT') then region = 'I   ';
  	else if state in ('NJ', 'NY', 'PR') then region = 'II  ';
  	else if state in ('DE', 'DC', 'MD', 'PA', 'VA', 'WV') then region = 'III ';
  	else if state in ('IL', 'IN', 'MI', 'MN', 'OH', 'WI') then region = 'V   ';
  	else if state in ('AR', 'LA', 'NM', 'OK', 'TX') then region = 'VI  ';
  	else if state in ('IA', 'KS', 'MO', 'NE') then region = 'VII ';
  	else if state in ('CO', 'MN', 'ND', 'SD', 'UT', 'WY') then region = 'VIII';
  	else if state in ('CA', 'AZ', 'HI', 'NV') then region = 'IX  ';
  	else if state in ('AK', 'ID', 'OR', 'WA') then region = 'X   ';
  	else region = 'IV  ';

  	if name = '' then name = name2;
run;

data salenroll; set salenroll;
	* Add region column; 
  	if index(name,'University') > 0 | index(name,'Univ') > 0 | index(name,'U.') > 0 or index(name,'U-') or index(name,'SUNY') > 0 then inst_type = 'U';
  	else if index(name,'Coll') > 0 then inst_type = 'C';
  	else inst_type = 'N';
run;

*Create a cross-tabulation of college type by region, displaying the count and the percent of each type within region;

proc freq data=salenroll;
	table region*type / nopercent nocol out = regtype;
run;

proc print data = regtype; run;

*Create a bar chart that shows the number of missing values for lecturer salary for each type of institution;

proc sort data=salenroll; by inst_type; run;

proc means noprint data=salenroll;
	by inst_type;
	var sal_asst;
	output out=miss_asst nmiss = misscount;
run;
	
proc chart data=miss_asst;
	vbar inst_type / type=sum sumvar= misscount;
run;

*Scatterplo;
proc plot data=salenroll;
	plot sal_all*num_ft_und=pub_priv;
run;

*Normality test;
proc sort data= salenroll; by inst_type region; 

proc univariate data= salenroll normal;
	where inst_type ~= 'N';
	by inst_type region;
	var sfratio;
	histogram sfratio / normal;
	inset mean std normaltest pnormal;
run;

*Create a small dataset with the mean value of meanexp by region;
proc sort data=salenroll; by region; run;

proc means noprint data=salenroll;
  by region;
  var exp_per_stud;
  output out=meanexp mean = mean_exp_reg;
run;

*proc print data=meanexp;

data salen2; 
  merge salenroll meanexp;
  by region;
run;

proc print data=salen2;
  where inst_type = 'N';
  var region state name exp_per_stud mean_exp_reg;
run;
	

	