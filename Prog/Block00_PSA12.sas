/**************************************************************************
 Program:  Block00_Psa12.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/04/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Census 2000 blocks (GeoBlk2000) to 
 Police Service Areas (Psa2012) correspondence file.

 Adds correspondence format $bk0psaf. to local General library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.Block00_Psa12 
  (label="Census 2000 blocks (GeoBlk2000) to Police Service Areas (Psa2012) correspondence file");

  set Octo.Block00_PolSA12;

  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    Geo2000 = "Full census tract ID (2000): ssccctttttt";

  ** PSA code **;
  
  %Octo_Psa2012( check=y )
  
  ** Police district code **;
  
  length PolDist2012 $ 2;
  
  PolDist2012 = put( poldist_id, 1. ) || 'D';
    
  label 
    PolDist2012 = "MPD Police District (2012)"
    poldist_id = "OCTO Police District ID"
    NAME = "OCTO PSA ID"
    PSA = "OCTO PSA code (number)"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 Psa2012 PolDist2012 NAME CJRTRACTBL x y;

run;

** Find duplicates **;

%Dup_check(
  data=General.Block00_Psa12,
  by=GeoBlk2000,
  id=Psa2012
)

proc sort data=General.Block00_Psa12 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_Psa12, stats=, freqvars=PolDist2012 Psa2012 )

run;

** Create correspondence formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0psaf,
  Data=General.Block00_Psa12,
  Value=GeoBlk2000,
  Label=Psa2012,
  OtherLabel="",
  Desc="Block 2000 to PSA 2012 correspondence",
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0pdaf,
  Data=General.Block00_Psa12,
  Value=GeoBlk2000,
  Label=PolDist2012,
  OtherLabel="",
  Desc="Block 2000 to PolDist 12 correspondence",
  Print=N,
  Contents=Y
  )

