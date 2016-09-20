
data num;
  input x;
  x1=x;
  x2=x;
  x3=x;
  x4=x;
  x5=x;
  x6=x;
  x7=x;
  format x1 8.5 x2 comma8. x3 dollar10.2 x4 e10. x5 roman20. x6 words60. x7 wordf50.;
  label x1='eightfive' x2='comma' x3='dollar' x4='E' x5='roman' x6='words' x7='wordf';
  cards;
126.73
5280
.00919
;
run;

proc print data=num label;
run;



data date;
  input d mmddyy6.;
  d1=d;
  d2=d;
  d3=d;
  d4=d;
  d5=d;
  d6=d;
  d7=d;
  output;
  input d date.;
  d1=d;
  d2=d;
  d3=d;
  d4=d;
  d5=d;
  d6=d;
  d7=d;
  output;
  input d date9.;
  d1=d;
  d2=d;
  d3=d;
  d4=d;
  d5=d;
  d6=d;
  d7=d;
  output;
  d='01JAN60'd;
  d1=d;
  d2=d;
  d3=d;
  d4=d;
  d5=d;
  d6=d;
  d7=d;
  output;
  attrib d  label='internal' 
         d1 label='mmddyy10' format=mmddyy10.
	     d2 label='mmddyy8' format=mmddyy8.
         d3 label='ddmmyy8' format=ddmmyy8.
         d4 label='date' format=date.
	     d5 label='worddate' format=worddate.
	     d6 label='weekdate' format=weekdate.
	     d7 label='downame' format=downame.;
cards;
102315
04JUL76
04JUL1776
;
run;

proc print data=date label;
run;




data m;
  input month @@;
  cards;
1 1 1 2 2 2 2 3 3 3 3 3 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 7 8 8 9 9 10 10 11 11 12 12 12
;
run;

proc freq data=m;
  table month;
run;

proc format;
  value season 1,2,12="Winter"
               3-5="Spring"
	  		   6-8="Summer"
	  		   9-11="Fall";
run;

proc freq data=m;
  format month season.;
  table month;
run;

proc format;
  value quarter low-3="Q1"
                4-6="Q2"
			    7-9="Q3"
			    10-high="Q4";
run;

proc freq data=m;
  format month quarter.;
  table month;
run;
