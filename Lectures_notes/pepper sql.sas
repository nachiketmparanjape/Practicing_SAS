

PROC SQL; 
 CONNECT TO EXCEL (PATH="e:\STAT 6740\Study 3 VOC.xlsx"); 

 CREATE TABLE green_raw as 
 SELECT * FROM CONNECTION TO EXCEL 
 (SELECT compound, date, day, rep1, rep2, rep3, rep4, rep5 FROM [Green Raw$]); 

 ALTER TABLE green_raw
 ADD type CHAR(10);

 UPDATE green_raw
 SET type="Green Raw";



 CREATE TABLE blanched as 
 SELECT * FROM CONNECTION TO EXCEL 
 (SELECT compound, date, day, rep1, rep2, rep3, rep4, rep5 FROM [Blanched$]); 
 ALTER TABLE blanched
 ADD type CHAR(10);
 UPDATE blanched
 SET type="Blanched";

 CREATE TABLE pureed as 
 SELECT * FROM CONNECTION TO EXCEL 
 (SELECT compound, date, day, rep1, rep2, rep3, rep4, rep5 FROM [Pureed$]); 
 ALTER TABLE pureed
 ADD type CHAR(10);
 UPDATE pureed
 SET type="Pureed";

 CREATE TABLE raw_sn as 
 SELECT * FROM CONNECTION TO EXCEL 
 (SELECT compound, date, day, rep1, rep2, rep3, rep4, rep5 FROM [Raw SnCl2$]); 
 ALTER TABLE raw_sn
 ADD type CHAR(10);
 UPDATE raw_sn
 SET type="Green Sn";

 DISCONNECT FROM EXCEL; 
QUIT; 


data allpep; set green_raw blanched pureed raw_sn;
  if rep1 = . then delete;
run;

proc contents data=allpep; run;

proc freq data=allpep;
  table compound*type day*type / nocol norow nopercent;
run;
