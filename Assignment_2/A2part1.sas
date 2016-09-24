*Set filename;
filename a1 '/folders/myfolders/Assignment_1/aaup_dat.txt';

*Define relevant dataset;
DATA salary;
	infile a1;
  	input fice 1 - 5 name $ 7 - 37 state $ 38 - 39 type $ 40 - 43 sal_full 44 - 48 Sal_assc 49 - 52 sal_asst 53 - 56 sal_all 57 - 60
		comp_full 61 - 65 comp_assc 66 - 69 comp_asst 70 - 73 comp_all 74 - 78 / num_full 1 - 4 num_assc 5 - 8 num_asst 9 - 12 num_inst 13 - 16 num_all 17 - 21;
	
	
	*Define a new column to specify a region by bracketing the corresponding states in corresponsing regions;
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

run;

*Created a dataset using usnews.csv;
PROC import datafile='/folders/myfolders/Assignment_2/usnews.csv' out=usnews dbms=csv replace;

*Renamed name columns as name2 to avoid confusiton before merging usnews and paranjape;
data usnews; set usnews;
name2 = name;
drop name;
run;

*Sorted dataset by the merging point - column 'fice';
proc sort data=salary; by fice; run;
proc sort data=usnews; by fice; run;

*Merged paranjape and usnews on fice;
data salenroll;
	merge salary usnews;
	by fice;
	
	if name = '' then name = name2;
run;

*Classification of universities based on what words/phrases their names contain;
data salenroll; set salenroll;
	*index = index(name,"California");
	if index(name,'University') > 0 | index(name,'Univ') > 0 | index(name,'U.') > 0 or index(name,'U-') or index(name,'SUNY') > 0 then inst_type = 'U';
  	else if index(name,'Coll') > 0 then inst_type = 'C';
  	else inst_type = 'N';
run;

*Subset the dataset for the condition where inst_type = N;
proc print data=salenroll;
  where inst_type = 'N';
run;

*Add new variables to salenroll;
data salenroll; set salenroll;
	pct_accepted = 100*num_acc/num_app;
	pct_enrolled = 100*num_enr/num_acc;
	cost_diff = books+fees+Instate_Tu+Room_board-Exp_per_stud;
run;

*Create 6 datasets by the institute types public and private;

data pubI pubIIA pubIIB privI privIIA privIIB; set salenroll;
	if pub_priv = 1 then do;
		if type = 'I' then output pubI;
		else if type = 'IIA' then output pubIIA;
		else if type = 'IIB' then output pubIIB;
	end;
	else do;
		if type = 'I' then output privI;
		else if type = 'IIA' then output privIIA;
		else if type = 'IIB' then output privIIB; 
	end;
run;

PROC contents data=pubIIA; run;

*Export an external sas dataset file;
libname sd '/folders/myfolders/Assignment_1/';

data sd.pubIIB; set pubIIB;
	keep region state name sal_all num_all num_ft_und sfration;
run;

*Import to an external csv;
proc export data=pubI outfile='/folders/myfolders/pubI.csv' dbms=csv; run;