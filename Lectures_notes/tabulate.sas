
proc import datafile = "f:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc print data=home; run;

proc sort data=home;  by ne cor; run;

* basic table;

proc tabulate data=home;
  class ne cor feats;
  table ne cor, feats;
run;

* variable labels;

proc tabulate data=home;
  class ne cor feats;
  table ne='NE area indicator' cor='Corner lot indicator', feats='Number of features';
run;

* ALL;

proc tabulate data=home;
  class ne cor feats;
  table (ne='NE area indicator' all='All areas') (cor='Corner lot indicator' all='All lot locations'),
	(feats='Number of features' all='All feature counts');
run;

* summary statistics;

proc tabulate data=home;
  class ne cor feats;
  var price;
  table feats='Number of features', (ne='NE area indicator' cor = 'Corner lot indicator')*price*(n min max mean);
run;

* multiple continuous variables;

proc tabulate data=home;
  class ne cor feats;
  var price tax;
  table feats='Number of features'*ne='NE area indicator'*cor = 'Corner lot indicator', (price tax)*(max mean);
run;

* different statistics for different variables AND labels for statistics;

proc tabulate data=home;
  class ne cor feats;
  var price tax;
  table feats='Number of features'*ne='NE area indicator'*cor = 'Corner lot indicator', (price*(min='Minimum' max='Maximum') tax*mean);
run;

* styles for proc vs class vs var vs table;

proc tabulate data=home;
  class ne cor feats;
  var sqft;
  table ne cor, feats*sqft*mean;
run;

proc tabulate data=home style=[color = red];
  class ne cor feats;
  var sqft;
  table ne cor, feats*sqft*mean;
run;

proc tabulate data=home;
  class ne cor feats / style=[color = red];
  var sqft;
  table ne cor, feats*sqft;
run;

proc tabulate data=home;
  class ne cor feats;
  var sqft / style=[color = red];
  table ne cor, feats*sqft*mean;
run;

proc tabulate data=home;
  class ne cor feats;
  var sqft;
  table ne cor, feats*sqft*mean / style=[color = red];
run;

proc tabulate data=home;
  class ne cor feats;
  var sqft;
  table ne cor, feats*sqft*mean;
run;

* formatting specific cells;

proc tabulate data=home;
  class ne cor feats;
  var sqft tax;
  table ne cor, feats*(sqft tax)*mean;
run;

proc tabulate data=home;
  class ne cor feats;
  var sqft tax;
  table ne cor, feats*(sqft*mean tax*mean);
run;

proc tabulate data=home;
  class ne cor feats;
  var sqft tax;
  table ne cor, feats*(sqft*mean tax*mean*[format=dollar12.2]);
run;
