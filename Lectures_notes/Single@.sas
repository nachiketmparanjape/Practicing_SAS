
data schedule(drop=type);
   retain Course Professor;
   input type $1. @;
   if type='C' then 
      input course $ professor $;
   else if type='S' then 
      do;
        input Name $11. Id;
        output schedule;
      end;
datalines;
C STAT6740   Naber
S Agyeman    6235
S Gerhardt   3991
S Gross      0698
S Johnson    3451
S Ku         2386
S Lalsare    9178
S McLaughlin 2025
S Orellana   1548
S Siddiqui   5849
S Walker     6729
S Wang       9958
S Xu         8546
C MATH202    Sen
S Lee        7085
S Williams   0459
S Flores     5423
;
run;

proc print; 
run;
