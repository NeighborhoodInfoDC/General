/**************************************************************************
 Program:  Block00_Anc12.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/04/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Advisory Neighborhood Commissions (anc2012) correspondence file.

 Adds correspondence format $bk0anaf. to local General library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.Block00_Anc12 
  (label="Census 2000 blocks (GeoBlk2000) to Advisory Neighborhood Commissions (Anc2012) correspondence file");

  set Octo.Block00_Anc12;

  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )
  
  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** ANC code **;
  
  %Octo_anc2012( check=y )

  label 
    ANC_ID = "OCTO ANC code"
    Name = "OCTO ANC name"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep anc2012 ANC_ID name GeoBlk2000 GeoBg2000 Geo2000 CJRTRACTBL x y;
  
run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_Anc12,
  by=GeoBlk2000,
  id=anc2012
)

proc sort data=General.Block00_Anc12 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_Anc12, stats=, freqvars=anc2012 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0anaf,
  Data=General.Block00_Anc12,
  Value=GeoBlk2000,
  Label=anc2012,
  OtherLabel="",
  Desc="Block 2000 to ANC 2012 correspondence",
  Print=N,
  Contents=Y
  )

