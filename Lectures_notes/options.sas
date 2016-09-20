
proc options;  run;


proc options define; run;

proc options short; run;

proc options value; run;

proc options listgroups; run;

proc options group = envdisplay; run;

proc options group = (sort sasfiles); run;

proc options host; run;

proc options option = bufsize; run;

proc options option = (errors linesize pagesize); run;

proc options restrict; run;



options nonumber; run;


options errors = 10 linesize = 120 pagesize = 60;

proc options option = (errors linesize pagesize); run;

options obs=10; run;



**** look at options using menu -- Tools / Options / System
