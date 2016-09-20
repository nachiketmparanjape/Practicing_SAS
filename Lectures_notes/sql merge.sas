
libname saved 'e:\STAT 6740\Data library\';


%macro readsort;

%do i = 1 %to 4;

data model&i; set saved.modelvars&i; run;
proc sort data=model&i; by geo_id2; run;

%end;

%mend readsort;

%readsort;


data model_all;
  merge model1 model2 model3 model4;
  by geo_id2;
run;


proc sql;
  create table model_all as
  select * from model1, model2, model3, model4
  where model1.geo_id2=model2.geo_id2 and model1.geo_id2=model3.geo_id2 and model1.geo_id2=model4.geo_id2
  order by model1.geo_id2;
quit;

proc contents data=model_all; run;






proc sql;
     create table model_all2 as 
     select *
     from
           (select * from saved.modelvars1) as a
     left join
           (select * from saved.modelvars2) as b
     on a.geo_id2 = b.geo_id2
     left join
           (select * from saved.modelvars3) as c
     on a.geo_id2 = c.geo_id2
	 left join
		   (select * from saved.modelvars4) as d
     on a.geo_id2 = d.geo_id2;
quit;

proc contents data=model_all2; run;
