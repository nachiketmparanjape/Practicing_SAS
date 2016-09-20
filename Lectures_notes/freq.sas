
proc import out = prov1 file = 'e:\STAT 6740\provider data.xlsx' dbms = xlsx; sheet = "provider data"; run;

proc contents data=prov1; run;

proc freq data=prov1;
  tables region county;
  tables type_of_care license_type type_of_registration regulation_status;
run;


data prov2; set prov1;
  if type_of_registration ~= '' then do;
    if index(type_of_registration,'ICCP') > 0 then iccp = 1; else iccp = 0;
    if index(type_of_registration,'State Licensed') > 0 then streg = 1; else streg = 0;
    if index(type_of_registration,'QRIS') > 0 then qris = 1; else qris = 0;
    if index(type_of_registration,'Community Only') > 0 then comm = 1; else comm = 0;
    if type_of_registration = '' then none = 1; else none = 0;
  end;

  if license_type ~= '' then do;
    if index(license_type, 'City') > 0 then ctlic = 1; else ctlic = 0;
    if index(license_type, 'Worker') > 0 then wklic = 1; else wklic = 0;
    if index(license_type, 'State') > 0 then stlic = 1; else stlic = 0;
    if index(license_type, 'Not currently') > 0 then nslic = 1; else nslic = 0;
  end;
run;

proc freq data=prov2;
  table stlic ctlic wklic nslic iccp streg qris comm none;
run;

proc freq data=prov2 order = data;
  tables region county;
run;

proc freq data=prov1;
  tables region*(type_of_care regulation_status license_type);
run;

proc freq data=prov2;
  tables region*type_of_care;
  tables type_of_care*region;
  tables type_of_care*region / nopercent norow nocol;
run;

proc sort data=prov2; by region; run;

proc freq data=prov2;
  by region;
  tables type_of_care*license_type / nopercent norow nocol out=freqout outpct;
run;

proc print data=freqout; run;

proc freq data=prov2;
  tables region*type_of_care / all;
run;

proc freq data=prov2 noprint;
  by region;
  tables type_of_care*license_type / measures;
  output out=statout measures;
run;

proc print data=statout; run;

proc freq data=prov2;
  tables region*type_of_care / chisq;
run;

proc freq data=prov2;
  tables iccp*ctlic / chisq;
run;
