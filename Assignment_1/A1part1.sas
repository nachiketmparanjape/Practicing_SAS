filename a1 "/folders/myfolders/Assignment_1/aaup_dat.txt";

*Created a temp dataset - salary from the using aaup_dat.txt;
data salary;
	infile a1;
	input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
			comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
run;

* Created a new temp dataset - naber, imported salary to it using 'set' and added a new column - region using if/else;
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
  pctfull = num_full * 100 / num_all;
  pctassc = num_assc * 100 / num_all;
  pctasst = num_asst * 100 / num_all;
  pctinst = num_inst * 100 / num_all;
  
run;

* Creates a dataset 'unnews' using import procedure;
proc import datafile ="/folders/myfolders/Assignment_1/usnews.csv" out = usnews dbms = csv replace;

*Re-creates a dataset 'usnews' and replaces name by name2 (why?);
data usnews; set usnews;
name2 = name;
drop name;
run;

* Print the dataset naber where region = I;
*proc print data=naber ; where region = 'I   '; run;

proc print data=naber; where region = 'I   '; var num_all;

