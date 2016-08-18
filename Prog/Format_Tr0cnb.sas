/**************************************************************************
 Program:  Format_Tr0cnb.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  7/31/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts 
 and Casey Target Area neighborhoods ($Tr0cnb).

   1 = Deanwood
   2 = Marshall Heights
   3 = Ft. Dupont Park
   9 = Not in Casey Target Area
   
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data Tr00_cnb (compress=no);

  length cnb $ 1 GEO2000 $ 11 ;

  input cnb geo2000;

cards;
1 11001007804
1 11001007808
1 11001009903
2 11001009904
2 11001009905
2 11001009906
3 11001007703
3 11001007707
3 11001009907
;

run;

proc sort data=Tr00_cnb;
  by geo2000;

data Tr00_cnb (compress=no);

  merge General.Geo2000 (keep=geo2000) Tr00_cnb;
  by geo2000;
  
  if cnb = "" then cnb = "9";
  
run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr0cnb,
  Data=Tr00_cnb,
  Value=geo2000, 
  Label=cnb,
  OtherLabel="",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc="Tract (2000)-Casey neighborhood corresp.",
  Contents=Y
  )

