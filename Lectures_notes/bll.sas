

libname s6740 "e:\STAT 6740\Data Library";


** Format plots to 5% intervals;

proc format;
  value pct1a 0 - 0.049999 = '< 5' 
			 0.05 - 0.099999 = '5 - 10'
		     0.10 - 0.149999 = '10 - 15'
			 0.15 - 0.199999 = '15 - 20'
			 0.20 - 0.249999 = '20 - 25'
			 0.25 - high = '> 25';

 run;

**  Read in predicted probabilities by census tract;

 data predprob05; set s6740.predprob05; run;

 proc contents data=predprob05; run;

** Import census tract map file and modify formats;

proc mapimport datafile="e:\STAT 6740\Data library\tl_2010_39_tract10.shp" 
	out=oh_tracts_2010;
  select countyfp10 tractce10;
  rename countyfp10=county tractce10=tract;
run;

proc contents data=oh_tracts_2010; run;

data oh_tracts_2010a; set oh_tracts_2010 (rename = (county = temp1 tract = temp2));
  co_fips = 1.*temp1;
  tract = 1.*temp2;
  drop temp1 temp2;
run;

** Combine predicted probabilities with map data;

proc sort data=oh_tracts_2010a; by co_fips tract; run;
proc sort data=predprob05; by co_fips tract; run;

data plot05;
  merge oh_tracts_2010a predprob05;
  by co_fips tract;
  if co_fips = . then delete;
run;

proc gproject data=plot05 out=tproj05 degrees eastlong;
  id co_fips tract;
run;

** Create and add dummy data to ensure plot keys contain all intervals;

data grouphelp5;
  do co_fips = 1 to 175 by 2;
    do interval = 1 to 6;
      pred_pct_05 = interval*0.05 - 0.025;
	  output;
	end;
  end;
run;

data tproj05a;
  set tproj05 grouphelp5;
  if pred_pct_05 = . then delete;
run;


** Create choroplth map of predicted probability of BLL >= 5 ug/dL for entire state;

filename grafout "e:\STAT 6740\Ohio05.emf";

options nodate nonumber;
ods html close;
ods printer printer=emf file=grafout;

goptions reset=all ftext='calibri' htext=2 gunit=pct gsfname=grafout gsfmode=replace device=emf;
goptions colors=(LemonChiffon, DarkSeaGreen, MediumSeaGreen, LightSeaGreen, Teal, DarkBlue);

title "Predicted Percentage of Children with BLL >= 5 ud/dL";

proc gmap data=tproj05 map=tproj05;
  id co_fips tract;
  choro pred_pct_05 / discrete;
  format pred_pct_05 pct1a.;
run;
quit;

ods printer close;
ods html;


proc gmap data=tproj05a map=tproj05a;
  id co_fips tract;
  choro pred_pct_05 / discrete;
  format pred_pct_05 pct1a.;
run;
quit;

** Create choropleth maps by county (probability BLL >= 5 or 10 ug/dL) -- Appendix B and C in Report;

%macro plotcounty(fips, cnty);

filename grafout1 "e:\STAT 6740\&cnty..emf";

options nodate nonumber;
ods html close;
ods printer printer=emf file=grafout1;

goptions reset=all ftext='calibri' htext=2 gunit=pct gsfname=grafout1 gsfmode=replace device=emf;
goptions colors=(LemonChiffon, DarkSeaGreen, MediumSeaGreen, LightSeaGreen, Teal, DarkBlue);

title "Predicted Percentage of Children with BLL >= 5 ug/dL for &cnty County";

proc gmap data=tproj05 map=tproj05;
  where co_fips = &fips;
  id co_fips tract;
  choro pred_pct_05 / discrete;
  format pred_pct_05 pct1a.;
run;
quit;

ods printer close;
ods html;

%mend plotcounty;


%plotcounty(1, ADAMS);
%plotcounty(3, ALLEN);
%plotcounty(5, ASHLAND);
%plotcounty(7, ASHTABULA);
%plotcounty(9, ATHENS);
%plotcounty(11, AUGLAIZE);
%plotcounty(13, BELMONT);
%plotcounty(15, BROWN);
%plotcounty(17, BUTLER);
%plotcounty(19, CARROLL);
%plotcounty(21, CHAMPAIGN);
%plotcounty(23, CLARK);
%plotcounty(25, CLERMONT);
%plotcounty(27, CLINTON);
%plotcounty(29, COLUMBIANA);
%plotcounty(31, COSHOCTON);
%plotcounty(33, CRAWFORD);
%plotcounty(35, CUYAHOGA);
%plotcounty(37, DARKE);
%plotcounty(39, DEFIANCE);
%plotcounty(41, DELAWARE);
%plotcounty(43, ERIE);
%plotcounty(45, FAIRFIELD);
%plotcounty(47, FAYETTE);
%plotcounty(49, FRANKLIN);
%plotcounty(51, FULTON);
%plotcounty(53, GALLIA);
%plotcounty(55, GEAUGA);
%plotcounty(57, GREENE);
%plotcounty(59, GUERNSEY);
%plotcounty(61, HAMILTON);
%plotcounty(63, HANCOCK);
%plotcounty(65, HARDIN);
%plotcounty(67, HARRISON);
%plotcounty(69, HENRY);
%plotcounty(71, HIGHLAND);
%plotcounty(73, HOCKING);
%plotcounty(75, HOLMES);
%plotcounty(77, HURON);
%plotcounty(79, JACKSON);
%plotcounty(81, JEFFERSON);
%plotcounty(83, KNOX);
%plotcounty(85, LAKE);
%plotcounty(87, LAWRENCE);
%plotcounty(89, LICKING);
%plotcounty(91, LOGAN);
%plotcounty(93, LORAIN);
%plotcounty(95, LUCAS);
%plotcounty(97, MADISON);
%plotcounty(99, MAHONING);
%plotcounty(101, MARION);
%plotcounty(103, MEDINA);
%plotcounty(105, MEIGS);
%plotcounty(107, MERCER);
%plotcounty(109, MIAMI);
%plotcounty(111, MONROE);
%plotcounty(113, MONTGOMERY);
%plotcounty(115, MORGAN);
%plotcounty(117, MORROW);
%plotcounty(119, MUSKINGUM);
%plotcounty(121, NOBLE);
%plotcounty(123, OTTAWA);
%plotcounty(125, PAULDING);
%plotcounty(127, PERRY);
%plotcounty(129, PICKAWAY);
%plotcounty(131, PIKE);
%plotcounty(133, PORTAGE);
%plotcounty(135, PREBLE);
%plotcounty(137, PUTNAM);
%plotcounty(139, RICHLAND);
%plotcounty(141, ROSS);
%plotcounty(143, SANDUSKY);
%plotcounty(145, SCIOTO);
%plotcounty(147, SENECA);
%plotcounty(149, SHELBY);
%plotcounty(151, STARK);
%plotcounty(153, SUMMIT);
%plotcounty(155, TRUMBULL);
%plotcounty(157, TUSCARAWAS);
%plotcounty(159, UNION);
%plotcounty(161, VAN WERT);
%plotcounty(163, VINTON);
%plotcounty(165, WARREN);
%plotcounty(167, WASHINGTON);
%plotcounty(169, WAYNE);
%plotcounty(171, WILLIAMS);
%plotcounty(173, WOOD);
%plotcounty(175, WYANDOT);



** Import zip code mapping file and format;

proc mapimport datafile="e:\STAT 6740\Data Library\tl_2010_39_zcta500.shp" 
	out=oh_zips_2010;
  select zcta5ce00;
  rename zcta5ce00= zip;
run;

data oh_zips_2010a; set oh_zips_2010 (rename = (zip = temp));
  zip = 1.*temp;
  drop temp;
run;

** Combine predicted probabilities with zip code map data;

proc sort data=oh_zips_2010a; by zip; run;

data zip05_b; 
  merge oh_zips_2010a s6740.hrzip05a;
  by zip;
run;

proc gproject data=zip05_b out=zproj05 degrees eastlong;
  id zip;
run;


** Map probability of BLL >= 5 by zip code;

filename grafout "e:\STAT 6740\Ohio_zip_05_max.emf";

options nodate nonumber;
ods html close;
ods printer printer=emf file=grafout;

goptions reset=all ftext='calibri' htext=2 gunit=pct gsfname=grafout gsfmode=replace device=emf;
goptions colors=(LemonChiffon, DarkSeaGreen, MediumSeaGreen, LightSeaGreen, Teal, DarkBlue);

title "Probability of BLL >= 5 ug/dL by Zip Code";

proc gmap data=zproj05 map=zproj05;
  id zip;
  choro pred_pct_05 / discrete;
  format pred_pct_05 pct1a.;
run;
quit;

ods printer close;
ods html;
