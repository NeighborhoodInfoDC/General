/**************************************************************************
 Program:  Block10_city.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/19/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 city (City) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1city,
  Data=General.Geoblk2010,
  Value=GeoBlk2010,
  Label="1",
  OtherLabel="",
  Desc="Block 2010 to city corresp",
  Print=N,
  Contents=Y
  )

