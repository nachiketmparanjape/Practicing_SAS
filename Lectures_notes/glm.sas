
proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=blanched;
  sheet = 'Blanched';
run;

proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=greenraw;
  sheet = 'Green Raw';
run;

proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=sncl;
  sheet = 'Raw SnCl2';
run;

proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=pureed;
  sheet = 'Pureed';
run;

data blanched2; set blanched;
  type = 'blanched';
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  
  drop rep1 - rep5;
run;

data greenraw2; set greenraw;
  type = 'greenraw';
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  
  drop rep1 - rep5;
run;

data sncl2; set sncl;
  type = 'SnCl2   ';
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  
  drop rep1 - rep5;
run;

data pureed2; set pureed;
  type = 'pureed  ';
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  
  drop rep1 - rep5;
run;

data allpeps; set greenraw2 sncl2 pureed2 blanched2; run;


proc glm data=blanched2;
  where compound = 'furfural';
  class day;
  model conc = day;
run;
  lsmeans day / adjust = tukey;
run;
quit;

proc glm data=allpeps;
  where compound = 'xylene';
  class type day;
  model conc = type day type*day / solution;
  means type;
run;
quit;


proc glm data=sncl;
  where compound = 'xylene' or compound = 'nonanal';
  class day;
  model rep1 - rep5 = day;
  manova h=day;
run;
quit;

