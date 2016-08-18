/**************************************************************************
 Program:  Format_Tr0cta.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  7/31/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts 
 and Casey Target Area ($Tr0cta).

   1 = Casey Target Area
   9 = Not Casey Target Area
   
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data Tr00_cta (compress=no);

  length cta $ 1 GEO2000 $ 11 ;

  input cta geo2000;

cards;
1 11001007804
1 11001007808
1 11001009903
1 11001009904
1 11001009905
1 11001009906
1 11001007703
1 11001007707
1 11001009907
;

run;

proc sort data=Tr00_cta;
  by geo2000;

data Tr00_cta (compress=no);

  merge General.Geo2000 (keep=geo2000) Tr00_cta;
  by geo2000;
  
  if cta = "" then cta = "9";
  
run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr0cta,
  Data=Tr00_cta,
  Value=geo2000, 
  Label=cta,
  OtherLabel="",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc="Tract (2000)-Casey target area corresp.",
  Contents=Y
  )

