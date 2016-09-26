* Import data;
filename sd "/folders/myfolders/files/aaup_dat.txt";

data salary;
	infile sd;
	input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;

proc import datafile="/folders/myfolders/files/usnews.csv"
	out=usnews dbms=csv replace;
run;

data usnews; set usnews;
	data2 = data;
	drop data;
run;

proc sort data=salary; by fice; run;
proc sort data=usnews; by fice; run;

data salenroll;
	merge salary usnews; by fice;
	if name = '' then name = name2;
run;

data salenroll; set salenroll;
	if state in ('CT', 'ME', 'MA', 'NH', 'RI', 'VT') then region = 1;
	else if state in ('NJ', 'NY', 'PR') then region = 2;
	else if state in ('DE', 'DC', 'MD', 'PA', 'VA', 'WV') then region = 3;
	else if state in ('IL', 'IN', 'MI', 'MN', 'OH', 'WI') then region = 4;
	else if state in ('AR', 'LA', 'NM', 'OK', 'TX') then region = 5;
	else if state in ('IA', 'KS', 'MO', 'NE') then region = 6;
	else if state in ('CO', 'MN', 'ND', 'SD', 'UT', 'WY') then region = 7;
	else if state in ('CA', 'AZ', 'HI', 'NV') then region = 8;
	else if state in ('AK', 'ID', 'OR', 'WA') then region = 9;
	else region = 10;
	format region roman10.;
run;

data salenroll; set salenroll;
  if index(name,'University') > 0 | index(name,'Univ') > 0 | index(name,'U.') > 0 or index(name,'U-') or index(name,'SUNY') > 0 then inst_type = 'U';
  else if index(name,'Coll') > 0 then inst_type = 'C';
  else inst_type = 'N';
  label inst_type = "Institute Type";
  
run;

* Tertiles;
proc sort data=salenroll; by state; run;

proc univariate noprint data= salenroll;
	by state;
	var sal_all num_ft_und;
	output out=terts pctlpts= 33 67 pctlpre=sal_all_ num_ft_und_ pctlname=pct33 pct67;
run;

data salpct;
	merge salenroll terts;
	by state;
	if sal_all = . then sal_ter = .;
	else if sal_all < sal_all_pct33 then sal_ter = 1;
	else if sal_all < sal_all_pct67 then sal_ter = 2;
	else sal_ter = 3;
	
	if num_ft_und = . then att_ter = .;
	else if num_ft_und < num_ft_und_pct33 then att_ter = 1;
	else if num_ft_und < num_ft_und_pct67 then att_ter = 2;
	else att_ter = 3;
run;

*formatting;
proc format;
	value tert 	1= 'Lower Third'
				2= 'Middle Third'
				3= 'Upper Third';
run;

data salpct; set salpct;
	format sal_ter att_ter tert.;
run;

*Boxplots for average assistant professor salary by university type;
proc sort data=salpct; by inst_type; run;

proc sgplot data=salpct;
  by inst_type;
  title 'Boxplot of Average Assistant Professor Salaries by Region for';
  footnote j=r 'Data from US News and AAUP';
  vbox sal_asst / category = region  connect=mean;
  xaxis label='DOE Region' ;
run;

*Scatterplot of average combined SAT scores versus student-faculty ratio for each combination of the salary and enrollment tertiles;

proc sort data=salpct; by sal_ter att_ter; run;

/* 	symbol1 i=none v=square c=red; */
/* 	symbol2 i=none v=triangle c=green; */
/* 	symbol3 i=none v=circle c=blue; */
/*  */
/* 	axis1 label = ('Average combined SAT Score') order = (0 to 1500 by 300); */
/* 	axis2 label = ('Student-faculty ratio') order = (0 to 100 by 10); */

proc sgplot data=salpct;
	
	where att_ter ne . and sal_ter ne .;
	title 'Average Combined SAT Score Versus Student-Faculty Ratio for #byval1 Salary and #byval2 Attendance';
	by sal_ter att_ter;
	*plot avsatcomb*sfratio=type / vaxis=axis1 haxis=axis2 vref=1500 href=15;
	scatter x=avsatcomb y=sfratio / group=inst_type;
	xaxis label='Average Combined SAT Score';
	yaxis label='Student to Faculty Ratio';
run;

*Bar chart that shows the total number of professors of all rank by region and university type;
	
/* axis1 label = ('Total number of faculty'); */
/* axis2 label = ('DOE Region'); */
/* axis3 label = ('University Type'); */
/*  */
/* pattern1 v=s c=red; */
/* pattern2 v=s c=green; */
/* pattern3 v=s c=blue; */

*Bar chart for total faculty count by region and unviersity type;
proc sgplot data=salpct;
	title 'Total faculty count by region and university type';
	vbar inst_type / response=num_all group=region ;
	*vbar type / group=region sumvar=num_all type=sum patternid=midpoint;
run;

proc sort data=salpct; by inst_type;

proc sgplot data=salpct;
	title 'Total faculty count by region and university type';
	by inst_type;
	vbar region / response=num_all;
	*vbar type / group=region sumvar=num_all type=sum patternid=midpoint;
run;