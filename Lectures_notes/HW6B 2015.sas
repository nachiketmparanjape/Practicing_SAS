
%macro pcicover(niter,p,n);

data d1;
  do i = 1 to &niter;
    x = ranbin(0,&n,&p);
    z = probit(0.975);
    lcb = x/&n - z*sqrt((x/&n)*(1-x/&n)/&n);
    ucb = x/&n + z*sqrt((x/&n)*(1-x/&n)/&n);
	if lcb < &p < ucb then cover = 1;
	else cover = 0;
    output;
  end;
run;

proc freq data=d1;
  table cover;
run;

%mend pcicover;

%pcicover(1000,0.5,50);

proc print data=d1; run;
