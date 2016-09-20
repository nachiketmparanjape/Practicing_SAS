


 
 
proc sql noprint;
select 
     distinct name into: orderedvars separated by ' '
from vars_base
     order by varnum;
quit;
 
 
*******************************************************;

 
%let modelname = 14Q;
 
proc sql;
create table work.prep as
select *,
     "&modelname" as sas_model_name,
     case
           when a.date lt '31jan2010'd then 1 else 0
           end as lsjan10 label='Reg E, 24Hr Grace,Posting Order Dummy',
     case
           when a.date ge '31oct2007'd then 1 else 0
           end as lsoct07 label='SKY Dummy'
from
     (select
         date,
           R_DISPOS_INC_US label'Real Disposable Income, National',
           YOY_PCE_US label='Year on year change to PCE',
           YOY_NONFARM_EMPLOY_US label='Year on year change to Nonfarm employment'
     from work.model_base) as a
left join
     (select
         date,
           &modelname
     from work.nii_nie
         where date le "&last_actual"d) as b
on a.date=b.date
left join
     (select
         date,
           &modelname as actuals
     from work.nii_nie) as c
on a.date=c.date;
 
quit;
