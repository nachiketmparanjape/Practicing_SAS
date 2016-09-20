
proc import out = blanched file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Blanched"; run;
proc import out = green_raw file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Green Raw"; run;
proc import out = raw_sn file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Raw SnCl2"; run;
proc import out = pureed file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Pureed"; run;


data green_raw2; set green_raw;
  trt = 'GR';
  if compound = 'ethanol';
  gr_conc = rep1;
  keep day gr_conc;
run;

data raw_sn2; set raw_sn;
  trt = 'RS';
  if compound = 'ethanol';
  rs_conc = rep1;
  keep day rs_conc;
run;

proc sort data=green_raw2; by day; run;
proc sort data=raw_sn2; by day; run;

data allraw1; 
  merge green_raw2 raw_sn2; 
  by day;
run;

proc print data=allraw1; run;

data green_raw3; set green_raw2 (drop = day); run;

proc sort data=green_raw3;  by gr_conc; run;

data allraw2; 
  merge green_raw3 raw_sn2; 
run;

proc print data=allraw2; run;

proc append data=raw_sn2 base=green_raw2; run;

proc append data=raw_sn base=green_raw; run;

proc print data=green_raw; 
  where compound = 'ethanol';
run;

proc means noprint data=raw_sn2;
  var rs_conc;
  output out=ave_sn2 mean=mean_sn2;
run;

data raw_sn3;
  if _n_ = 1 then set ave_sn2;
  set raw_sn2;
run;

proc print data=raw_sn3; run;
