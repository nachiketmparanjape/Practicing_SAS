
data example4;
  input region $7. +4 jansales 5.;
  *input region $7. @12 jansales 5.; 
  datalines;
REGION1    49670
REGION2    97540
REGION3    86342
;
run;

proc print; run;
