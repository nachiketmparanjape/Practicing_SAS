
filename abc 'e:\STAT 6740\glmoutput';
filename def 'e:\STAT 6740\log';


* Need macro to perform power analysis for ANOVA with several factors;

%macro mcrunoff(nrep, niter, esig, psig, rsig, tf1, tf2);

proc printto print=abc; run;
proc printto log=def; run;

%do iter = 1 %to &niter;

data runoff1;
  do irep = 1 to &nrep;
    do plot = 1 to 8;
	  plot_eff = &psig*rannor(0);
	  if plot < 4 then trt = 1;
	  else if plot < 7 then trt = 2;
	  else trt = 0;
	  if trt = 0 then trt_eff = 0;
	  else if trt = 1 then trt_eff = &tf1;
	  else trt_eff = &tf2;
	  do event = 1 to 4;
	    event_eff = &esig*rannor(0);
		tmdl = trt_eff + plot_eff + event_eff + &rsig*rannor(0);
		output;
	  end;
	end;
  end;
run;

proc glm data=runoff1;
  class trt plot event irep;
  model tmdl = trt plot(trt) event trt*event irep;
  random plot(trt) irep;
  lsmeans trt / e=plot(trt) adjust=tukey pdiff cl;
  ods output lsmeandiffcl=trtmeans;
run;

data trtmeans1; set trtmeans;
  if i = 2;
  if sign(Lowercl) = sign(uppercl) then sig = 1; else sig = 0;
  iteration = &iter;
  n_rep = &nrep;
  teff1 = &tf1;
  teff2 = &tf2;
  keep rep effect sig n_rep teff1 teff2;
run;

%if &iter = 1 %then %do;
  data alliter; set trtmeans1; run;
%end;

%if &iter > 1 %then %do;
   data alliter; set alliter trtmeans1; run;
%end;

%end;

proc printto; run;

proc freq data=alliter;
  table sig;
run;

%mend mcrunoff;

%mcrunoff(3, 100, .65, .16, .65, 0.3, 0.45);
%mcrunoff(5, 100, .65, .16, .65, 0.3, 0.45);
%mcrunoff(10, 100, .65, .16, .65, 0.3, 0.45);
%mcrunoff(3, 100, .65, .16, .65, 0.3, 0.6);
%mcrunoff(5, 100, .65, .16, .65, 0.3, 0.6);
%mcrunoff(10, 100, .65, .16, .65, 0.3, 0.6);
%mcrunoff(3, 500, .65, .16, .65, 0.3, 0.9);
%mcrunoff(5, 500, .65, .16, .65, 0.3, 0.9);
%mcrunoff(10, 500, .65, .16, .65, 0.3, 0.9);
