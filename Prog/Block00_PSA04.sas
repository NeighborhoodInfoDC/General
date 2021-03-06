************************************************************************
* Program:  Block00_PSA04.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  09/08/04
* Version:  SAS 8.12
* Environment:  Windows
* 
* Description:  Create Census 2000 block to PSA (2004) file 
* from ArcGIS (DBF) source.
*
* NOTE:  Program requires DBMS/Engines
*
* Modifications:
*  9/9/04  Corrected PSA code to use NAME instead of GIS_ID.
*  03/30/06  Updated, added correspondence format.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( OCTO )

libname Octo_dbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4
  block="Block00_PolSA04";

*options obs=50;

data General.Block00_PSA04 
  (label="Census 2000 blocks (GeoBlk2000) to Police Service Areas (PSA2004) correspondence file");

  set Octo_dbf.block;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** PSA code **;
  
  %Octo_Psa2004()
  
  ** Police district code **;
  
  length PolDist2004 $ 2;
  
  PolDist2004 = POLDIST_ID;
    
  label 
    PolDist2004 = "MPD Police District (2004)"
    CJRTRACTBL = "OCTO tract/block ID"
    Gis_id = "OCTO PSA ID"
    NAME = "PSA code (number)"
    X = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    Y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats **;
  
  format _all_ ;
  informat _all_ ;
  
  format x y 10.2;

  keep Geo2000 GeoBlk2000 Psa2004 PolDist2004 CJRTRACTBL Gis_id NAME x y;

run;

** Find duplicates **;

%Dup_check(
  data=General.Block00_PSA04,
  by=GeoBlk2000,
  id=Psa2004
)

proc sort data=General.Block00_PSA04 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_PSA04, stats=, freqvars=PolDist2004 PSA2004 )

run;

** Create correspondence formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0ps4f,
  Data=General.Block00_PSA04,
  Value=GeoBlk2000,
  Label=Psa2004,
  OtherLabel="",
  Desc="Block 2000 to PSA 2004 correspondence",
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0pd4f,
  Data=General.Block00_PSA04,
  Value=GeoBlk2000,
  Label=PolDist2004,
  OtherLabel="",
  Desc="Block 2000 to PolDist 04 correspondence",
  Print=N,
  Contents=Y
  )

