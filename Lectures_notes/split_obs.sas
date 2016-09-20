

proc import out = blanched file = 'f:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Blanched"; run;


data blanched2; set blanched;
  rep = 1; conc = rep1; output;
  rep = 2; conc = rep2; output;
  rep = 3; conc = rep3; output;
  rep = 4; conc = rep4; output;
  rep = 5; conc = rep5; output;
  
  drop rep1 - rep5;
run;

proc print data=blanched;
  where compound = 'furfural';
run;

proc print data=blanched2;
  where compound = 'furfural';
run;
















proc import out = green_raw file = 'f:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Green Raw"; run;

%macro greenrep;

data green2; set green_raw;
  %do i = 1 %to 5;
    rep = &i; conc = rep&i; output;
  %end;
run;

%mend;

%greenrep;

proc print data=green2;
  where compound = 'xylene';
run;
