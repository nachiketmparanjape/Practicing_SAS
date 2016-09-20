
proc import out = blanched file = 'f:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Blanched"; run;

data blanched2; set blanched;
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  
  drop rep1 - rep5;
run;

proc univariate data=blanched2 normal plot;
  where compound = 'methanol';
  var conc;
  histogram conc / normal lognormal;
  inset n mean std skew kurt;
  cdfplot conc / normal;
  probplot conc / normal;
  qqplot conc / gamma(alpha = 10.3);
  ppplot conc / igauss;
  output out=uni_out mean = mean_conc p90 = p90_conc t = t_conc probt = tp_conc;
run;

proc print data=uni_out; run;

proc means data=blanched2 n mean std min max median;
  where compound = 'butanal';
  var conc;
run;

proc sort data=blanched2 out=blanched3; by compound day; run;

proc means data=blanched3 noprint;
  by compound;
  var conc;
  output out=blanchedstats n = nobs mean=meanconc std=stdconc;
run;

proc print data=blanchedstats; run;

data blanched4;
  merge blanched3 blanchedstats;
  by compound;
run;

proc print data=blanched4;
  where compound = 'octanal';
run;
