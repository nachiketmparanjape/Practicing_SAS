
libname leslie SPSS "U:\STAT 6740\Data\LW.por";
libname folder "U:\STAT 6740\Data";

data modelout; set leslie._first_; run;

data folder.lw; set modelout; run;

proc datasets library=folder; run;
