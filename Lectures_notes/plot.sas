
filename sjn 'e:\STAT 6740\tv.txt';

data doctv;
  infile sjn;
  input country $ 1-14 life_exp 16-19 people_per_tv 21-23 people_per_doc 25-29 fem_life 31-32 mal_life 34-35;
run;

proc plot data=doctv;
  plot people_per_tv*life_exp;
run;

proc plot data=doctv;
  plot fem_life*mal_life = 'X';
  plot life_exp*people_per_doc = country;
run;

proc plot data=doctv;
  plot life_exp*(people_per_tv people_per_doc);
run;

proc plot data=doctv;
  plot people_per_doc*fem_life = 'F' people_per_doc*mal_life = 'M' / overlay;
run;

proc plot data=doctv;
  plot people_per_doc*fem_life $ country / haxis = 45 to 85 by 5 vref = 20000;
run;

proc plot data=doctv;
  plot people_per_tv*people_per_doc = life_exp / contour = 5;
run;

