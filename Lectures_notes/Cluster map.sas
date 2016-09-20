

proc contents data=maps.counties; run;

data state;
  set maps.counties(where=(state=stfips("OH"))); 
        *stfips function creates FIPS number from 2-letter postal code; 

  call symput('stname',stnamel("OH"));  
  		*stnamel converts 2-letter state code to mixed-case state name;
  		*SYMPUT assigns the value 'Ohio' to the macro variable 'stname';
run;

proc gproject data=state out=stateprj;
  id state;
run;

* gproject converts from spherical coordinates to Cartesian coordinates needed for GMAP;

proc import datafile = "f:\STAT 6740\County Clusters - modclus.CSV"
	dbms = csv out = countycode replace;
run;

proc print data=countycode; run;

*  need to have county be the fips code, so we rename variables
	-- also rename clusters to letters rather than numbers;

data countycode; set countycode(rename = (county = temp1 fips = temp2));
	rename temp1 = county_name;
	rename temp2 = county;
	if c4 = 1 then cluster = 'A';
	else if c4 = 3 then cluster = 'B';
	else if c4 = 4 then cluster = 'C';
	else cluster = 'D';
run;

* merge the map data with the cluster data;

data stateprj1; merge stateprj countycode; by county; run;


%ANNOMAC; ** need to run this to use mapping macro later;

goptions colors=(LemonChiffon, DarkSeaGreen, MediumSeaGreen, LightSeaGreen, Teal);

%maplabel (stateprj1, countycode, ohco, county_name, county, font=Arial Black, color=black, size=1, hsys=3); 
  * creates an output dataset that can be used to annotate the map
	- arguments are map-dataset name, attribute dataset name, output dataset name, label variable, id variables,
		font for labels, color for labels, size of labels, coordinate system unit identifier;

proc gmap map=stateprj1 data=stateprj1;
  id state county;  * identifies variables that define the map area;
  choro cluster/discrete annotate=ohco;
  		* discrete generates separate color for each level of response variable
  		* annotate identifies annotation dataset;
run;
quit;


proc gmap map=stateprj1 data=stateprj1;
  id state county;  * identifies variables that define the map area;
  choro c6/discrete annotate=ohco;
  		* discrete generates separate color for each level of response variable
  		* annotate identifies annotation dataset;
run;
quit;
