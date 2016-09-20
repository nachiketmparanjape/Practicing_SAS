
proc import datafile = "e:\Stat 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc contents data=home; run;

proc sort data=home; by ne cor cust; run;

data home2; set home; by ne cor cust;
  ne_f = first.ne;
  ne_l = last.ne;
  cor_f = first.cor;
  cor_l = last.cor;
  cust_f = first.cust;
  cust_l = last.cust;
run;

proc print data=home2; run;
