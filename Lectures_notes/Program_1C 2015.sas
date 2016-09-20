

libname saved 'u:\STAT 6740\Data library\';

data model1; set saved.modelvars1; run;
data model2; set saved.modelvars2; run;
data model3; set saved.modelvars3; run;
data model4; set saved.modelvars4; run;

proc contents data=model1; run;
proc contents data=model2; run;
proc contents data=model3; run;
proc contents data=model4; run;

data modelvars1_ext; set model1;
  rat_yg_old = pct_age_5 / pct_age_65;
  pct_white = 100 - pct_black - pct_asian - pct_hisp - pct_mixed;

  max_rc_pct = max(pct_white, pct_black, pct_asian, pct_hisp, pct_mixed);
  if max_rc_pct = pct_white then max_race = 'White';
  else if max_rc_pct = pct_black then max_race = 'Black';
  else if max_rc_pct = pct_asian then max_race = 'Asian';
  else if max_rc_pct = pct_hisp then max_race = 'Hisp ';
  else max_race = 'Mixed';

  num_white = round(num_pop*pct_white/100);
  num_black = round(num_pop*pct_black/100);
  num_asian = round(num_pop*pct_asian/100);
  num_hisp  = round(num_pop*pct_hisp/100);
  num_mixed = round(num_pop*pct_mixed/100);
run;

proc print data=model2; run;
proc print data=model3; run;
proc print data=model4; run;

proc print data=modelvars1_ext;
  where pct_white < 50;
  var geo_id2 num_pop pct_mixed num_mixed;
run;

proc print data=modelvars1_ext;
  where pct_hisp > pct_black;
  var geo_id2 num_pop pct_hisp pct_black;
run;

proc print data=modelvars1_ext;
  where pct_age_5 > 20 | pct_age_65 > 20;
  var geo_id2 pct_age_5 pct_age_65 num_pop;
run;

proc print data=modelvars1_ext;
  where pct_age_5 > 10 & max_race = 'Black';
run;
