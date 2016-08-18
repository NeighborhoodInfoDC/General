/**************************************************************************
 Program:  Format_Tr0eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  10/05/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts 
 and East of the River ($Tr0eor).

   1 = East of the River
   9 = Not East of the River
   
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data Tr00_eor (compress=no);

  length EOR $ 1 GEO2000 $ 11 ;

  input EOR geo2000;

cards;
1 11001007301
1 11001007302
1 11001007304
1 11001007308
1 11001007401
1 11001007403
1 11001007404
1 11001007406
1 11001007407
1 11001007408
1 11001007409
1 11001007502
1 11001007503
1 11001007504
1 11001007601
1 11001007603
1 11001007604
1 11001007605
1 11001007703
1 11001007707
1 11001007708
1 11001007709
1 11001007803
1 11001007804
1 11001007806
1 11001007807
1 11001007808
1 11001007809
1 11001009601
1 11001009602
1 11001009603
1 11001009604
1 11001009700
1 11001009801
1 11001009802
1 11001009803
1 11001009804
1 11001009806
1 11001009807
1 11001009808
1 11001009809
1 11001009901
1 11001009902
1 11001009903
1 11001009904
1 11001009905
1 11001009906
1 11001009907
;

run;

proc sort data=Tr00_eor;
  by geo2000;

data Tr00_eor (compress=no);

  merge General.Geo2000 (keep=geo2000) Tr00_eor;
  by geo2000;
  
  if eor = "" then eor = "9";
  
run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr0eor,
  Data=Tr00_eor,
  Value=geo2000, 
  Label=EOR,
  OtherLabel="",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc="Tract (2000)-EOR correspondence",
  Contents=Y
  )

