
proc import datafile='e:\STAT 6740\Study 3 VOC.xlsx' dbms = xlsx out=blanched;
  sheet  = 'Blanched'; 
run;

proc contents data=blanched; run;

proc sort data=blanched nodupkey out=dateinfo; by date; run;

proc print data=dateinfo; run;

data dateinfo; set dateinfo;
  year = year(date);
  day_mo = day(date);
  month = month(date);
  qrtr = qtr(date);
run;

proc print data=dateinfo; run;

data dateref;
  today = date();
  today2 = mdy(9,18,2015);
  output;
run;

proc print data=dateref; run;

data dateinfo2;
  if _n_ = 1 then set dateref;
  set dateinfo;
run;

proc print data=dateinfo2; run;

data dateinfo2; set dateinfo2;
  days = today - date;
run;
  
proc print data=dateinfo2; run;
