
* Step 1 -- Read data;

%let conc = 'u:/STAT 6740/Data/Hartwell Concentrations.csv';
%let deep = 'u:/STAT 6740/Data/Hartwell Depth.csv';

proc import datafile=&conc dbms = csv out=concdat replace; run;
proc import datafile=&deep dbms = csv out=deepdat replace; run;

proc sort data=concdat; by sample homolog; run;

footnote j=r 'Data from the U.S. EPA';

* Step 2 -- Transpose concentration and merge with depth;

proc transpose data=concdat out=conctrans prefix=conc;
  by sample;
  var Concdep1 - Concdep17;
  id homolog;
run;

data conctrans2; set conctrans;
  cnc1 = 1.*conc1;
  cnc2 = 1.*conc2;
  cnc3 = 1.*conc3;
  cnc4 = 1.*conc4;
  cnc5 = 1.*conc5;
  cnc6 = 1.*conc6;
  cnc7 = 1.*conc7;
  cnc8 = 1.*conc8;
  cnc9 = 1.*conc9;
  cnc10 = 1.*conc10;

  if cnc1 ne .;
  depth = substr(_name_,8,2);
  samp_id = sample;

  drop _name_ sample conc1 - conc10;
run;

data deep2; set deepdat;
  loc2 = find(sample,'-',5);
  samp_id = substr(sample,1,loc2-1);
  depth = substr(sample,loc2+1,2);

  drop sample loc2;
run;

proc sort data=conctrans2; by samp_id depth; run;
proc sort data=deep2; by samp_id depth; run;

data concdeep;
  merge conctrans2 deep2;
  by samp_id depth;
run;

* proc contents data=concdeep; run;

* Step 3;

proc tabulate data=concdeep;
  Title 'Summary Statistics for Ten Congener Concentrations by Sampling Location';
  class samp_id;
  var cnc1 - cnc10;
  table samp_id*(cnc1 - cnc10),(n='Number of Depths' min='Minimum Conc' max='Maximum Conc' mean='Mean Conc' lclm='LCB for Mean Conc' uclm='UCB for Mean Conc');
run;

* Step 4 - Bar charts;

proc format;
  value depc 1 = 'Less than 25'
  			 2 = 'Between 25 and 75'
			 3 = 'More than 75'; 
run;

data depcat; set concdeep;
  format depcat depc.;
  if upper_depth < 25 then depcat = 1;
  else if upper_depth < 75 then depcat = 2;
  else depcat = 3;
run;

axis1 label = ('Mean Concentration') logbase = 10 logstyle = expand;
axis2 label = ('Sampling Location');
axis3 label = ('Depth Category');

pattern1 c=green;
pattern2 c=red;
pattern3 c=blue;

proc gchart data=depcat;
  title 'Mean Concentration for Congener 3 by Sampling Location and Sample Depth';
  vbar samp_id / group = depcat sumvar = cnc3 type = mean maxis = axis2 gaxis = axis3 axis = axis1 patternid = group;
run;

proc gchart data=depcat;
  title 'Mean Concentration for Congener 6 by Sampling Location and Sample Depth';
  vbar samp_id / group = depcat sumvar = cnc6 type = mean maxis = axis2 gaxis = axis3 axis = axis1 patternid = group;
run;

* Step 5 - Scatterplots;

proc sgscatter data=depcat;
  title 'Scatterplots of Congener Concentrations with Histograms';
  matrix cnc3 - cnc8 / diagonal=(histogram normal) group=depcat;
run;

* Step 6 - Univariate;
 
data c45rat; set depcat;
  c45_rat = cnc4/cnc5;
run;

proc univariate data=c45rat normal;
  ods select histogram;
  var c45_rat;
  histogram c45_rat / normal lognormal(theta=est);
  inset normaltest pnormal;
run;

*  Step 7 - Output SAS dataset;

%let outlib = 'u:/STAT 6740/Data Library/';
libname ol &outlib;

data hlog; set concdeep;
  homolog = 1; conc = cnc1; output;
  homolog = 2; conc = cnc2; output;
  homolog = 3; conc = cnc3; output;
  homolog = 4; conc = cnc4; output;
  homolog = 5; conc = cnc5; output;
  homolog = 6; conc = cnc6; output;
  homolog = 7; conc = cnc7; output;
  homolog = 8; conc = cnc8; output;
  homolog = 9; conc = cnc9; output;
  homolog = 10; conc = cnc10; output;

  drop cnc1 - cnc10;
run;

proc sort data=hlog; by samp_id homolog conc; run;
proc sort data=hlog out=hlog2 nodupkeys; by samp_id homolog; run;

data maxconc; set hlog; by samp_id homolog conc;
  if last.homolog;
run;

data ol.maxconc; set maxconc; run;


** Alternative for Step 7;

data maxc1; set concdat;
  maxconc = max (of Concdep1 - Concdep17);
  keep sample homolog maxconc;
run;

data ol.maxconc; set maxc1; run;
