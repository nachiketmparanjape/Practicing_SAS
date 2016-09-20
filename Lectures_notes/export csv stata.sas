
proc import out = blanched file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Blanched"; run;
proc import out = green_raw file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Green Raw"; run;
proc import out = raw_sn file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Raw SnCl2"; run;
proc import out = pureed file = 'e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx; sheet = "Pureed"; run;

proc export data=pureed OUTFILE= "e:\STAT 6740\pureedpepper.csv" DBMS=csv; 
run;

proc export data=blanched OUTFILE= "e:\STAT 6740\blanchedpepper.dta" DBMS=stata; 
run;
