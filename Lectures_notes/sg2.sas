
proc import datafile = "e:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc sort data=home; by feats; run;

proc boxplot data=home;
  plot (tax price)*feats / boxconnect=mean cconnect=green vaxis = 0 to 2500 by 500 outbox=temp;
  insetgroup n min max;
run;

proc print data=temp; run;














proc sgpanel data=home;
  panelby ne cor / layout=lattice;
  reg x=sqft y=price / alpha = 0.1 clm='Confidence Band for Line';
run;














proc sgscatter data=home;
  matrix price tax sqft age / ellipse=(type = predicted) diagonal = (histogram normal);
run;

proc sgscatter data=home;
  compare X=(sqft feats) Y=(tax price) / group = ne ellipse=(type = predicted);
run;

proc sgscatter data=home;
  plot price*(sqft tax) / group = ne ellipse=(type = predicted) pbspline;
run;
