
proc import datafile = "f:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc contents data=home; run;


*** BASIC BAR CHART;

proc gchart data=home;
  vbar feats;
run;

















*** ADD AXIS LABEL AND BAR PATTERN;

axis1 label = ('Number of Features');
pattern1 c=red v=e;

proc gchart data=home;
  vbar feats / caxis = green ctext=blue maxis=axis1;
run;












*** 3D BARS WITH DEFINED SHAPE AND REFERENCE LINES;

proc gchart data=home;
  vbar3d feats / caxis = green ctext=blue maxis=axis1 shape=c ref=10 to 50 by 10;
run;













*** ADD A GROUP VARIABLE;



pattern1 c=blue v=l2;
pattern2 c=red v=r2;

proc gchart data=home;
  vbar feats / maxis=axis1 group=ne;
run;












*** ADD A SUBGROUP AND RESPONSE AXIS LABEL;


pattern1 c=blue v=l2;
pattern2 c=red v=r2;
axis2 label=(a=90 j=center 'Number of Houses');

proc gchart data=home;
  vbar feats / maxis=axis1 raxis=axis2 subgroup=ne;
run;










*** CHANGE DIRECTION AND ANGLE OF RESPONSE AXIS LABEL;

axis2 label=(a=270 r=90 j=center 'Number of Houses');

proc gchart data=home;
  vbar feats / maxis=axis1 raxis=axis2 subgroup=ne;
run;












*** HORIZONTAL BARS WITH GROUP AND SUBGROUP;

axis2 label=(a=0 r=0 j=center 'Number of Houses');

proc gchart data=home;
  hbar3d feats / maxis=axis1 raxis=axis2 group=cor subgroup=ne;
run;










*** BAR CHART FOR CONTINUOUS VARIABLE;

axis1 label = ('Property Tax Paid');

proc gchart data=home;
  hbar tax / maxis=axis1;
run;















*** DEFINE BAR MIDPOINTS AND REVERSE AXIS;

proc gchart data=home;
  hbar tax / maxis=axis1 midpoints = 1800 to 200 by -200;
run;









*** USE SUMVAR AND ERROR BARS;

proc gchart data=home;
  vbar ne / group = cor type=mean sumvar = tax midpoints=0 1 errorbar=bars outside = sum;
run;









*** BLOCK CHART;

proc gchart data=home;
  block feats / discrete group = cor subgroup = ne type=mean sumvar = tax;
run;








*** DONUT CHART;

pattern1 c=oldlace v=p3x90;
pattern2 c=cream v=p3x90;
pattern3 c=sandybrown v=p3x90;
pattern4 c=darksalmon v=p3x90;
pattern5 c=brilliantorange v=p3x90;
pattern6 c=rose v=p3x90;
pattern7 c=orangered v=p3x90;
pattern8 c=vividpink v=p3x90;
pattern9 c=firebrick v=p3x90;

proc gchart data=home;
  donut feats;
run;










*** MOVE LABELS AND LABEL OTHER CATEGORY;

proc gchart data=home;
  donut feats / value=inside slice=outside otherlabel='0, 7 or 8';
run;













*** DONUT WITH GROUP;

proc gchart data=home;
  donut feats / group=ne value=inside slice=none otherlabel='0, 7 or 8';
run;














*** DONUT WITH SUBGROUP;

proc gchart data=home;
  donut feats / subgroup=ne value=inside slice=none otherlabel='0, 7 or 8';
run;
