

/*this is for loading the data*/

%macro pim(sheet);

proc import out= treat.&sheet

    datafile = '/home/u63213341/Home/Treatment/data.xlsx'

    dbms = xlsx;

    sheet = "&sheet";

    getnames = yes;

run;

%mend pim;



/*converting the weight to kg*/
%macro check_weight(dsn=);
data &dsn.;
set &dsn.;
if WGTBLU="lb" then do;
 WGTBL=WGTBL*0.45;
 WGTBLU="kg";
  end;
run;
%mend check_weight;


%macro check_height(dsn=);
data &dsn.;
set &dsn.;
if HGTBLU="m" and HGTBL>2.5 then HGTBL=HGTBL*0.01;
run;
%mend check_height;


%macro preprocessing_ex1(dsn=);
data Treat.ADLB_ex1;
set &dsn.;
where PARAMCD="C64849B" and (VISITNUM=10 and ANL01FL="Y");
run;
%mend preprocessing_ex1;


%macro preprocessing_ex2(dsn=);
data Treat.ADLB_ex2;
set &dsn.;
where PARAMCD="C64849B"and ANL01FL="Y" ;
run;
%mend preprocessing_ex2;


%macro remove_duplicate(dsn=);
proc sort data=&dsn. out=&dsn.; by SUBJID; run;
data &dsn.;
set &dsn.;
by SUBJID;
if last.SUBJID;
run;
%mend remove_duplicate;


%macro add_weeknumber(dsn=);
data &dsn.(drop=New_STR Weeknumber1);
set &dsn.;
weeknumber1=substr(AVISIT,15,3);
NEW_STR = transtrn(weeknumber1,')',trimn(''));
WeekNumber=input(NEW_STR,best.);
run;

%mend add_weeknumber;


%macro merge_tables(dsn1=,dsn2=,col=);
proc sort data=&dsn1. ;by &col.;run;
proc sort data=&dsn2. ;by &col.;run;
data Treat.dataEx1;
merge &dsn1. (in=a)
&dsn2. (in=b);
by &col.;
if a;
run;
%mend merge_tables;










/*Main part of running*/

%pim(ADSL);
%pim(ADLB);

%check_weight(dsn=Treat.ADSL);
%check_height(dsn=Treat.ADSL);

%preprocessing_ex1(dsn=Treat.ADLB);
%preprocessing_ex2(dsn=Treat.ADLB);


%remove_duplicate(dsn=Treat.ADLB_EX1);

%add_weeknumber(dsn=Treat.ADLB_EX2);


%merge_tables(dsn1=Treat.ADSL,dsn2=Treat.ADLB_EX1,col=SUBJID);

Data Treat.DataEx1;
set Treat.DataEx1;
rename AVAL=HbA1c ;
run; 


proc means data=Treat.DataEx1 (drop=visitnum);





/*
proc means data=Treat.ADLB_ex2 mean ;
class  WeekNumber TRTP;
output out=Treat.MeanOut;
run;
*/

                                                                                                                       
 *Ex2

proc sql;
create table Treat.New as
select mean(AVAL) as mean_AVAL ,TRTP, WEEKNUMBER  from Treat.ADLB_ex2 
 group by  TRTP , WeekNumber;

quit;




ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=TREAT.NEW;
    title color=black "Treatment" color=blue;
	scatter x=WeekNumber y=mean_AVAL / group=TRTP;
	series x=WeekNumber y=mean_AVAL / group=TRTP;
	refline 6.5 / axis=y lineattrs=(thickness=2 color=green) label="6.5" ;
	refline 7.5 / axis=y lineattrs=(thickness=2 color=green) label="7.5" ;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset; 