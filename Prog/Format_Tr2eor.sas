/**************************************************************************
 Program:  Format_Tr2eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/04/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Correspondence format between 2010 tracts 
 and East of the River ($Tr2eor).

   1 = East of the River
   9 = Not East of the River
   
 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;


data Tr20_eor (compress=no);

  length EOR $ 1 geo2020 $ 11 ;

  retain EOR '1';

  input geo2020;

cards;
11001007301
11001007304
11001007401
11001007403
11001007404
11001007406
11001007407
11001007408
11001007409
11001007502
11001007503
11001007504
11001007601
11001007603
11001007604
11001007605
11001007703
11001007707
11001007708
11001007709
11001007803
11001007804
11001007806
11001007807
11001007808
11001007809
11001009601
11001009602
11001009603
11001009604
11001009700
11001009801
11001009802
11001009803
11001009804
11001009807
11001009810
11001009811
11001009901
11001009902
11001009903
11001009904
11001009905
11001009906
11001009907
11001010400
11001010900
;

run;

proc sort data=Tr20_eor;
  by geo2020;

data Tr20_eor (compress=no);

  merge General.geo2020 (keep=geo2020 where=(geo2020 =: "11")) Tr20_eor;
  by geo2020;
  
  if eor = "" then eor = "9";
  
run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr2eor,
  Data=Tr20_eor,
  Value=geo2020, 
  Label=EOR,
  OtherLabel="",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc="Tract (2020)-EOR correspondence",
  Contents=Y
  )

