

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
data Treat.ex1;
set &dsn.;
where PARAMCD="C64849B" and VISITNUM=10 ;
run;
%mend preprocessing_ex1;


%macro preprocessing_ex2(dsn=);
data Treat.ex2;
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



/*Main part of running*/

%pim(ADSL);
%pim(ADLB);

%check_weight(dsn=Treat.ADSL);
%check_height(dsn=Treat.ADSL);

%preprocessing_ex1(dsn=Treat.ADLB);
%preprocessing_ex2(dsn=Treat.ADLB);


%remove_duplicate(dsn=Treat.EX1);

%add_weeknumber(dsn=Treat.EX2);








                                                                                                                           
  
