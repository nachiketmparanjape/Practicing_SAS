
*Step 1;

proc format;
  value risk 0 = 'Low Risk' 1 = 'High Risk';
run;

libname saved 'f:\STAT 6740\Data library\';

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

data allmodel2; set allmodel;
  format ibr ifr iur iar risk.;

  if pct_black > 75 then ibr = 1; else ibr = 0;
  if pct_f_head > 25 then ifr = 1; else ifr = 0;
  if pct_unemploy > 20 then iur = 1; else iur = 0;
  if pct_pre_50 > 33 then iar = 1; else iar = 0;

  num_rf = sum(ibr, ifr, iur, iar);

  label ibr = 'Risk due to race'
  		ifr = 'Risk due to female head'
		iur = 'Risk due to unemployment'
		iar = 'Risk due to age of home';
run;

data allmodel3; set allmodel2;
  if iar = 0 then do;
    if ifr = 0 then iafr = 0;
	else iafr = 1;
  end;
  else do;
    if ifr = 0 then iafr = 2;
	else iafr = 3;
  end;


  numle5 = pct_age_5*num_pop/100;
run;

* Step 2;


pattern1 v=l2 c=black;
pattern2 v=x2 c=green;
pattern3 v=r2 c=blue;
pattern4 v=s c=red;

proc gchart data=allmodel3;
  vbar ibr / group = iur subgroup = iafr sumvar = numle5 type = sum patternid = subgroup discrete;
run;

* Step 3;

proc format;
  value pctdec 0 -  9.999999 = 'Less than 10 percent'
  			  10 - 19.999999 = '10 - 20 percent'
			  20 - 29.999999 = '20 - 30 percent'
			  30 - 39.999999 = '30 - 40 percent'
			  40 - 49.999999 = '40 - 50 percent'
			  50 - 59.999999 = '50 - 60 percent'
			  60 - 69.999999 = '60 - 70 percent'
			  70 - 79.999999 = '70 - 80 percent'
			  80 - 89.999999 = '80 - 90 percent'
			  90 - 1000 = 'More than 90 percent';
run;

data allmodel3; set allmodel3;
  format pct_renter pctdec.;
run;

goptions colors = (AliceBlue, Aqua, Azure, Blue, BlueViolet, CadetBlue, CornFlowerBlue, DarkBlue, DarkSlateBlue, DodgerBlue);

proc gchart data=allmodel3;
  title 'Counts of Census Tracts with Various Percentages of Renters';
  pie pct_renter / value = inside legend otherlabel = 'Less than 10 percent';
run;


* Step 4;

data allmodel3; set allmodel3;
  label pct_married = 'Percent Households with Married Couple'
		pct_fr_00 = 'Percent of Households Immigrated since 2000'
		pct_hs_ed = 'Percent of People with HS Degree';
run;

proc g3d data=allmodel3;
  title 'Relationship between Percent Married, Percent Recent Immigrants and Percent with HS Degree';
  footnote j=r 'Data from US Census Bureau';
  scatter pct_married*pct_fr_00=pct_hs_ed / shape = 'square'  color = 'green' rotate = 30 tilt = 45 grid;
run;

