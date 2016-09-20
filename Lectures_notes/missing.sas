
filename sjn 'e:\tv.txt';

data doctv;
  infile sjn;
  input country $ 1-14 life_exp 16-19 people_per_tv 21-23 people_per_doc 25-29 fem_life 31-32 mal_life 34-35;
run;

proc print data=doctv; run;

data doctv2; set doctv;
  tv_per_doc1 = people_per_doc / people_per_tv;
  if people_per_tv = . then people_per_tv = 0;
  tv_per_doc2 = people_per_doc / people_per_tv;
  if life_exp > 70 then group = 'older';
run;

proc print data=doctv2; run;

