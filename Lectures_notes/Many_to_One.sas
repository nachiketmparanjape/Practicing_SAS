
data original;
  input Event_Id $ chem_num chem_name $ conc;
datalines;
BH1S	1	Arsenic	12.7
BH1S	2	Chromium	221
BH1S	3	Copper	187
BH1S	4	Lead	163
BH1S	5	Nickel	49.9
BH1S	6	Zinc	264
BH1T	2	Arsenic	5.24
BH1T	4	Chromium	2.15
BH1T	5	Copper	2.47
BH1T	6	Lead	0.223
BH1T	7	Nickel	1.3
BH1T	8	Zinc	15.4
BH041S	1	Arsenic	13.38162537
BH041S	2	Chromium	225.6300962
BH041S	3	Copper	154.361661
BH041S	4	Lead	120.2154333
BH041S	5	Nickel	35.97401266
BH041S	6	Zinc	255.9879469
BWP1S	1	Arsenic	19.9
BWP1S	2	Chromium	244.8140392
BWP1S	3	Copper	304.7580532
BWP1S	4	Lead	438.0488287
BWP1S	5	Nickel	46.7
BWP1S	6	Zinc	638.0101393
;
run;

data new; set original;
  if chem_name = 'Arsenic' then ar = conc;
  if chem_name = 'Chromium' then cr = conc;
  if chem_name = 'Copper' then cu = conc;
  if chem_name = 'Lead' then pb = conc;
  if chem_name = 'Nickel' then ni = conc;
  if chem_name = 'Zinc' then zn = conc;

  drop chem_num chem_name conc;
run;

proc print data=new; run;

proc sort data=new;  by event_id; run;

proc means noprint data=new;
  by event_id;
  var ar cr cu pb ni zn;
  output out=final max = ;
run;

proc print data=final; run;
























proc sort data=original; by event_id; run;

proc transpose data=original out=new1;
  by event_id;
  var conc;
  id chem_name;
run;

proc print data=new1; run;
























proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=blanched replace;
  sheet = 'Blanched';
run;

proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=greenraw replace;
  sheet = 'Green Raw';
run;

proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=sncl replace;
  sheet = 'Raw SnCl2';
run;

proc import dbms=xlsx file = 'f:\STAT 6740\Study 3 VOC.xlsx' out=pureed replace;
  sheet = 'Pureed';
run;

data blanched; set blanched;
  type = 'Blanched';
run;

data greenraw; set greenraw;
  type = 'GreenRaw';
run;

data sncl; set sncl;
  type = 'SnCl2   ';
run;

data pureed; set pureed;
  type = 'Pureed  ';
run;

data allpeps; set blanched greenraw sncl pureed; run;

proc sort data=allpeps; by type date day; run;

proc transpose data=allpeps out=allpeps2;
  by type date day;
  var rep1 - rep5;
  id compound;
run;

proc print data=allpeps2; run;
