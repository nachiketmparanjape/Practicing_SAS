
* Step 1;

filename a1 "e:\STAT 6740\aaup_dat.txt";

data salary;
  infile a1;
  input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;


proc import datafile = "e:\STAT 6740\usnews.csv"
  out = usnews dbms = csv replace;
run;

data usnews; set usnews;
  name2 = name;
  drop name;
run;

proc sort data=salary; by fice; run;
proc sort data=usnews; by fice; run;

data salenroll;
  merge salary usnews;
  by fice;
  format region roman10.;
  if state in ('CT', 'ME', 'MA', 'NH', 'RI', 'VT') then region = 1;
  else if state in ('NJ', 'NY', 'PR') then region = 2;
  else if state in ('DE', 'DC', 'MD', 'PA', 'VA', 'WV') then region = 3;
  else if state in ('IL', 'IN', 'MI', 'MN', 'OH', 'WI') then region = 5;
  else if state in ('AR', 'LA', 'NM', 'OK', 'TX') then region = 6;
  else if state in ('IA', 'KS', 'MO', 'NE') then region = 7;
  else if state in ('CO', 'MN', 'ND', 'SD', 'UT', 'WY') then region = 8;
  else if state in ('CA', 'AZ', 'HI', 'NV') then region = 9;
  else if state in ('AK', 'ID', 'OR', 'WA') then region = 10;
  else region = 4;

  if name = '' then name = name2;
run;

proc contents data=salenroll; run;

data se2; set salenroll;
  rank = 'Asst'; salary = sal_asst; numfac = num_asst; output;
  rank = 'Assc'; salary = sal_assc; numfac = num_assc; output;
  rank = 'Full'; salary= sal_full;  numfac = num_full; output;
run;

data se3; set salenroll;
  as_at_saldiff = sal_assc - sal_asst;
  f_as_saldiff = sal_full - sal_assc;
  f_at_saldiff = sal_full - sal_asst;
run;

%macro steve(region, type);

proc sgplot data=se2;
  where region = &region & type=&type;
  title "Mean Salary and Total Faculty Count for Region &region and Type &type";
  vbar rank / response = salary stat = mean;
  vline rank / response = numfac stat = sum y2axis;
run;

proc tabulate data=se3;
  where region = &region & type=&type;
  title "Comparison of Salaries between Rank by State for Region &region and Type &type";
  class state;
  var as_at_saldiff f_as_saldiff f_at_saldiff;
  table state, (as_at_saldiff f_as_saldiff f_at_saldiff)*(mean t probt);
run;


%mend steve;

%steve(9, 'IIB');
%steve(4, 'IIA');
