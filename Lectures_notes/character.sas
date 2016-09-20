
filename sjn 'e:\STAT 6740\tv.txt';

data doctv;
  infile sjn;
  input country $ 1-14 life_exp 16-19 people_per_tv 21-23 people_per_doc 25-29 fem_life 31-32 mal_life 34-35;
run;

proc contents data=doctv; run;

data doctv2; set doctv;
  if life_exp < 60 then lecat = 'Short ';
  else if life_exp < 70 then lecat = 'Medium';
  else lecat = 'Long  ';
run;

proc print data=doctv2; run;

data doctv3; set doctv2;
  country_short = substr(country, 1, 4);
  country_le = country_short||lecat;
run;

proc print data=doctv3; run;

data doctv4; set doctv3;
  a_loc = index(country, 'a');
  ver1 = verify(country, 'qxz');
  ver2 = verify(country, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
run;

proc print data=doctv4; run;

data doctv5; set doctv4;
  country2 = upcase(country);
  country3 = lowcase(country2);
  country4 = upcase(substr(country3,1,1))||substr(country3,2,13);
run;

proc print data=doctv5; run;

data doctv6; set doctv5;
  country5 = right(country);
  country6 = left(country5);
  country7 = compress(country);
run;

proc print data=doctv6; run;

data doctv7; set doctv;
  test1 = translate(country,'AEIOU','aeiou');
  test2 = tranwrd(country,'ia','eeyah');
run;

proc print data=doctv7; run;

