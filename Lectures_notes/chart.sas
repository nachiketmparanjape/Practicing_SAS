
proc import datafile = "e:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc contents data=home; run;

proc chart data=home;
  vbar feats;
run;

proc chart data=home;
  vbar feats / group = cor;
run;

proc chart data=home;
  vbar feats / group = cor subgroup = ne;
run;

proc chart data=home;
  vbar feats / type = cpercent;
run;

proc chart data=home;
  vbar feats / type = sum sumvar = tax;
run;

proc chart data=home;
  vbar feats / type = sum sumvar = tax midpoints = 0 to 8;
run;

proc chart data=home;
  vbar feats / type = mean sumvar = price midpoints = 0 to 8;
run;

proc chart data=home;
  vbar price;
run;

proc chart data=home;
  pie feats;
run;

proc chart data=home;
  hbar feats;
run;

proc chart data=home;
  block feats / group = ne;
run;

options linesize = 200;

proc chart data=home;
  block feats / group = ne;
run;


proc plot data=home;
  plot price*(feats age sqft);
run;
