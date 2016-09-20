
LIBNAME abc excel 'e:\STAT 6740\Study 3 VOC.xlsx' ver=2007 mixed=yes;

proc datasets library = abc; run;

data blanched; set abc.'Blanched$'n; run;
data green_raw; set abc.'Green Raw$'n; run;
data raw_sn; set abc.'Raw SnCl2$'n; run;
data pureed; set abc.'Pureed$'n; run;

proc contents data=blanched; run;

proc import out = blanched file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Blanched"; run;
proc import out = green_raw file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Green Raw"; run;
proc import out = raw_sn file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Raw SnCl2"; run;
proc import out = pureed file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Pureed"; run;

proc print data=pureed;
  where day = 0;
run;
