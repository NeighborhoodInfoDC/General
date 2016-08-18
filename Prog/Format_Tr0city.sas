/**************************************************************************
 Program:  Format_Tr0city.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/22/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts and Washington,
 D.C.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

/*
** Define libraries **;
%DCData_lib( General )
*/

data Tr00_city (compress=no);

  set General.Geo2000 (keep=geo2000);
  
  city = "1";
  
run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr0city,
  Data=Tr00_city,
  Value=geo2000, 
  Label=city,
  OtherLabel="",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc="Tract (2000)-city correspondence",
  Contents=Y
  )

run;
