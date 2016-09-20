
proc import datafile = "e:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;




proc sgplot data=home;
  scatter x=age y=sqft;
run;

proc sgplot data=home;
  scatter x=age y=sqft;
  ellipse x=age y=sqft;
run;

proc sgplot data=home;
  scatter x=age y=sqft / markerchar=ne;
  ellipse x=age y=sqft / lineattrs = (color=maroon);
run;





proc sgplot data=home;
  bubble x=age y=sqft size=feats;
run;





proc sgplot data=home;
  histogram tax;
run;

proc sgplot data=home;
  histogram tax / fillattrs = (color=palegreen) binstart=0 binwidth=200 showbins;
  density tax / type=normal lineattrs = (color=red);
run;





proc sgplot data=home;
  vbar feats;
run;

proc sgplot data=home;
  vbar feats / group=ne response=price stat=mean barwidth=0.6 dataskin=sheen;
run;

proc sgplot data=home;
  vbar feats / response=tax stat=mean limitstat=clm limitattrs = (thickness = 3);
run;

proc sgplot data=home;
  vbar feats / response = price stat=mean transparency = 0.5;
  vbar feats / response = tax stat=mean barwidth = 0.6;
run;

proc sgplot data=home;
  vbar feats / response = price stat=mean transparency = 0.5;
  vbar feats / response = tax y2axis stat=mean barwidth = 0.6;
run;



proc sgplot data=home;
  hbox price;
run;

proc sgplot data=home;
  vbox price / group = cor category = ne connect = median notches;
run;





proc sort data=home;  by feats; run;
 
proc means noprint data=home;
  by feats;
  var price tax age;
  output out=home2 mean=;
run;


proc sgplot data=home2;
  series x=feats y=price;
run;


proc sgplot data=home2;
  series x=feats y=price / curevelabel = 'Mean Price' markers;
  series x=feats y=tax / curevelabel = 'Mean Tax' markers;
  series x=feats y=age / curevelabel = 'Mean Age' y2axis markers;
run;


proc sgplot data=home;
  vector x=age y=sqft / xorigin=25 yorigin=2000 group=ne;
run;


proc sgplot data=home;
  reg x=sqft y=price / clm cli;
run;


proc sgplot data=home;
  vbar feats / response=price stat=mean;
  vline feats / response = tax stat=mean y2axis limitstat=stderr markers markerattrs=(color=red) lineattrs=(color=red);
  xaxis label='Number of Features';
  yaxis label='Average Home Price (X 100)';
  y2axis label='Average Tax Rate';
run;


proc sgplot data=home;
  loess x=age y=sqft / clm clmtransparency = 0.5;
run;



proc sgplot data=home;
  waterfall category = feats response = price;
run;


proc sgplot data=home;
  dot feats;
run;




proc sort data=home;  by feats; run;
 
proc means noprint data=home;
  by feats;
  var price;
  output out=home3 min=minprice max=maxprice;
run;

proc sgplot data=home3;
  highlow x=feats high=maxprice low=minprice / highcap = filledarrow lowcap = filledarrow;
run;
