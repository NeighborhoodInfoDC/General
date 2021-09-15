/**************************************************************************
 Program:  Block20_city.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/13/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 city (City) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2city,
  Data=Geoblk2020,
  Value=GeoBlk2020,
  Label="1",
  OtherLabel="",
  Desc="Block 2020 to city correspondence",
  Print=N,
  Contents=Y
  )


