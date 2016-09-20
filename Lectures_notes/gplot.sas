
proc import datafile = "e:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc contents data=home; run;


proc sort data=home;  by ne cor; run;

proc gplot data=home;
  plot tax*price;
run;








data home; set home;
  label tax = 'Prop Tax'
  		price = 'Sale Price';
run;

proc gplot data=home;
  plot tax*price;
run;






axis1 label=('Property Tax') order = (0 to 2000 by 500);
axis2 label=('Home Price') order = (0 to 2500 by 500) value=('0' '50000' '100000' '150000' '200000' '250000');

symbol v=circle c=seagreen;

proc gplot data=home;
  plot tax*price / haxis=axis2 vaxis=axis1;
run;





symbol1 v=circle c=seagreen;
symbol2 v=square c=lightsalmon;

proc gplot data=home;
  plot tax*price=ne / haxis=axis2 vaxis=axis1;
run;





proc gplot data=home;
  plot price*feats / vaxis=axis1 grid;
run;





proc gplot data=home;
  bubble tax*price=feats / bcolor=red;
run;





proc gplot data=home;
  bubble tax*price=feats / bcolor=red bsize=15;
run;





proc gplot data=home;
  plot tax*feats / vaxis = axis1;
  plot2 price*feats / vaxis = axis2;
run;





symbol1 v=circle c=red i=rl;

proc gplot;
  plot tax*price;
run;






symbol1 v=circle c=red i=rl ci=blue;

proc gplot;
  plot tax*price / regeqn;
run;







symbol1 i=boxj;

proc gplot;
  plot tax*feats;
run;
