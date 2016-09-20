
filename a1 "U:\STAT 6740\Data\aaup_dat.txt";

data salary;
  infile a1;
  input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;

data naber; set salary;
  if state in ('CT', 'ME', 'MA', 'NH', 'RI', 'VT') then region = 'I   ';
  else if state in ('NJ', 'NY', 'PR') then region = 'II  ';
  else if state in ('DE', 'DC', 'MD', 'PA', 'VA', 'WV') then region = 'III ';
  else if state in ('IL', 'IN', 'MI', 'MN', 'OH', 'WI') then region = 'V   ';
  else if state in ('AR', 'LA', 'NM', 'OK', 'TX') then region = 'VI  ';
  else if state in ('IA', 'KS', 'MO', 'NE') then region = 'VII ';
  else if state in ('CO', 'MN', 'ND', 'SD', 'UT', 'WY') then region = 'VIII';
  else if state in ('CA', 'AZ', 'HI', 'NV') then region = 'IX  ';
  else if state in ('AK', 'ID', 'OR', 'WA') then region = 'X   ';
  else region = 'IV  ';

  totsalfull = num_full*sal_full;
  totfac = num_full + num_assc + num_asst + num_inst;
  pct_full = 100*num_full/num_all;
  pct_assc = 100*num_assc/num_all;
  pct_asst = 100*num_asst/num_all;
  pct_inst = 100*num_inst/num_all;
  rat_asst_assc = sal_asst / sal_assc;

run;

proc print data=naber;
  where region = 'VII';
run;

proc print data=naber;
  where type = 'I';
  var name region state comp_full comp_assc comp_asst;
run;

proc print data=naber;
  where region = 'X'; 
  var name state totsalfull;
run;

proc print data=naber;
  where state = 'CA';
  var name region state type num_all totfac;
run;

proc print data=naber;
  where state = 'OH' & type = 'IIA';
run;

