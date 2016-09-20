
proc import datafile = "f:\STAT 6740\\homeprices.csv"
	dbms = csv out = home replace;
run;

proc print data=home; run;

data home2; set home;
  label price = 'Home price'
  		sqft = 'Square footage'
		age = 'Age of home'
		feats = 'Number of features'
		ne = 'Northeast location indicator'
		cust = 'Customized home indicator'
		cor = 'Corner lot indicator'
		tax = 'Property tax';
 run;

title 'Home Price and Tax Data';
footnote 'Data from US News';

proc print data=home2; run;

proc contents data=home2; run;

proc tabulate data=home2;
  class feats ne;
  var tax;
  table feats,ne*tax*mean;
run;

Title ' ';

proc tabulate data=home2;
  class feats ne;
  var tax;
  table feats,ne*tax*mean;
run;

proc sort data=home2; by cor; run;

proc tabulate data=home2;
  by cor;
  title 'Homeprice data for corner lot indicator = #byval1';
  class feats ne;
  var tax;
  table feats,ne*tax*mean;
run;

TITLE H=1.0 'The last word is ' H=3.0 'LARGER';

proc freq data=home2;
  table ne*cor / nopercent norow nocol;
run;
