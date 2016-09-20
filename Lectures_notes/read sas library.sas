
libname saved 'f:\STAT 6740\Data library\';

proc datasets library=saved; run;

data test1; set saved.adipose0final; run;

proc print data=test1; run;

data test2; set saved.data10192011; run;

proc print data=saved.data10192011; run;
