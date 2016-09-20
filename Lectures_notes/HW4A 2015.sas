
* Step 1;

filename a1 "U:\STAT 6740\Data\aaup_dat.txt";

data salary;
  infile a1;
  input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;


proc import datafile = "U:\STAT 6740\Data\usnews.csv"
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
  else if state in ('DE', 'DC', 'MD', 'PA', 'VA', 'WV') then region = 2;
  else if state in ('IL', 'IN', 'MI', 'MN', 'OH', 'WI') then region = 5;
  else if state in ('AR', 'LA', 'NM', 'OK', 'TX') then region = 6;
  else if state in ('IA', 'KS', 'MO', 'NE') then region = 7;
  else if state in ('CO', 'MN', 'ND', 'SD', 'UT', 'WY') then region = 8;
  else if state in ('CA', 'AZ', 'HI', 'NV') then region = 9;
  else if state in ('AK', 'ID', 'OR', 'WA') then region = 10;
  else region = 4;

  if name = '' then name = name2;
run;

data salenroll; set salenroll;
  if index(name,'University') > 0 | index(name,'Univ') > 0 | index(name,'U.') > 0 or index(name,'U-') or index(name,'SUNY') > 0 then inst_type = 'U';
  else if index(name,'Coll') > 0 then inst_type = 'C';
  else inst_type = 'N';
run;

* Step 2;

proc tabulate data=salenroll;
  title 'Summary Statistics for Student-Faculty Ratio and Average Faculty Salary';
  footnote j=r 'Data from 1994 AAUP and US News Sources';
  class type region;
  var sfratio sal_all;
  table region*type, (sfratio sal_all)*(n='Number of Schools' min='Minimum' max='Maximum' median='Median' mean='Mean' std='Standard Deviation');
  label region = 'DOE Region' Type = 'University Type' sfratio = 'Student-to-Faculty Ratio' sal_all = 'Average Salary - All Ranks';
run;


* Step 3;

proc sort data=salenroll; by state; run;

proc univariate noprint data=salenroll;
  by state;
  var sal_all Num_FT_und;
  output out=terts  pctlpts = 33 67 pctlpre = sal_all_ num_ft_und_ pctlname = pct33 pct67;
run;

proc contents data=terts; run;

data salpct;
  merge salenroll terts;
  by state;

  if sal_all = . then sal_ter = .;
  else if sal_all < sal_all_pct33 then sal_ter = 1;
  else if sal_all < sal_all_pct67 then sal_ter = 2;
  else sal_ter = 3;

  if num_ft_und = . then att_ter = .;
  else if num_ft_und < num_ft_und_pct33 then att_ter = 1;
  else if num_ft_und < num_ft_und_pct67 then att_ter = 2;
  else att_ter = 3;
run;

  
* Step 4;

proc format;
  value tert 1 = 'Lower third'
  			 2 = 'Middle third'
			 3 = 'Upper third';
run;

data salpct; set salpct;
  format sal_ter att_ter tert.;
run;


* Step 5;

proc tabulate data=salpct format = 8.1;
  title 'Summary Statistics for Combined SAT scores by Salary and Attendance Tertiles';
  class sal_ter att_ter;
  var avsatcomb;
  table sal_ter*att_ter,avsatcomb*(min='Minimum' q1='First Quartile' median='Median' q3='Third Quartile' max='Maximum');
  label sal_ter='Salary Tertiles' att_ter='Attendance Tertiles' avsatcomb='Average Combined SAT Scores';
run;


