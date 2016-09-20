
proc import datafile = "e:\STAT 6740\homeprices.csv"
	dbms = csv out = home replace;
run;

proc contents data=home; run;


*** BASIC 3D SCATTERPLOT;

proc g3d data=home;
  scatter sqft*age=price;
run;















*** ADD POINT PATTERNS;

proc g3d data=home;
  scatter sqft*age=price / grid color='red' shape = 'diamond';
run;














*** DEFINE Z AXIS;

axis1 order = (0 to 2500 by 500);
axis2 order = (0 to 3000 by 500);
axis3 order = (0 to 60 by 10);


proc g3d data=home;
  scatter sqft*age=price / grid color='red' shape = 'diamond' zaxis=axis1 xaxis=axis2 yaxis=axis3;
run;



proc g3d data=home;
  scatter sqft*age=price / grid color='red' shape = 'diamond' zmin=0 zmax=2500 zticknum=6 xticknum=6 yticknum=6;
run;









*** 3D PLOT ROTATED AND ANGLED;

proc g3d data=home;
  scatter sqft*age=price / grid color='red' shape = 'diamond' zmin=0 zmax=2500 zticknum=5 rotate=45 tilt=45;
run;













** ADD A SIZE VARIABLE;

proc g3d data=home;
  scatter sqft*age=price / grid color='red' shape = 'balloon' zmin=0 zmax=2500 zticknum=5 tilt=45 rotate=45 size=feats;
run;











*** CREATE A GRID OF DATA AND USE PLOT STATEMENT;


proc g3grid data=home out=homegrid;
  grid sqft*age=price;
run;

proc contents data=homegrid; run;

proc g3d data=homegrid;
  plot sqft*age=price;
run;












*** ROTATE AND TILT;

proc g3d data=homegrid;
  plot sqft*age=price / rotate=45 tilt=45;
run;










*** FINER GRID;

proc g3grid data=home out=homegrid;
  grid sqft*age=price / naxis1=20 naxis2=20 near=5;
run;












*** ROTATE AND TILT and XTYPE;

proc g3d data=homegrid;
  plot sqft*age=price / rotate=45 tilt=45 grid xytype = 1 side;
run;











*** GCONTOUR;

proc gcontour data=homegrid;
  plot sqft*age=price;
run;









*** USE SOLID PATTERNS AND DEFINE PATTERN LEVELS;

proc gcontour data=homegrid;
  plot sqft*age=price / pattern levels = 450 to 4500 by 500;
run;










data hat;
   do x=-5 to 5 by .25;
      do y=-5 to 5 by .25;
         z=sin(sqrt(x*x+y*y));
         output;
      end;
   end;
run;


proc g3d data=hat;
   plot y*x=z;
   title 'Cowboy Hat with G3D';
run;
quit;


proc g3d data=hat;
   plot y*x=z / grid rotate=45 tilt = 45;
   title 'Cowboy Hat with G3D';
run;
quit;

proc g3d data=hat;
   plot y*x=z / rotate=5 tilt = 5;
   title 'Cowboy Hat with G3D';
run;
quit;


proc g3d data=hat;
   plot y*x=z / grid rotate=85 tilt = 85 xticknum = 11 yticknum = 11 zticknum = 11;
   title 'Cowboy Hat with G3D';
run;
quit;
