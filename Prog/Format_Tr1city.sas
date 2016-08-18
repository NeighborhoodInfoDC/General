/**************************************************************************
 Program:  Format_Tr1city.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/22/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts and Washington, D.C.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

data Tr10_city (compress=no);

  set General.Geo2010 (keep=geo2010);
  
  city = "1";
  
run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr1city,
  Data=Tr10_city,
  Value=geo2010, 
  Label=city,
  OtherLabel="",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc="Tract (2010)-city correspondence",
  Contents=Y
  )

run;
