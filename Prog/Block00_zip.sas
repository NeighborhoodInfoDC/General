************************************************************************
* Program:  Block00_Zip.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  03/30/06
* Version:  SAS 8.12
* Environment:  Windows
* 
* Description:  Create Census 2000 block to ZIP code file 
* from ArcGIS (DBF) source.
*
* NOTE:  Program requires DBMS/Engines
*
* Modifications:
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( OCTO )

libname Octo_dbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4
  block="Block00_Zip";

*options obs=50;

data General.Block00_Zip 
  (label="Census 2000 blocks (GeoBlk2000) to ZIP codes correspondence file");

  set Octo_dbf.block;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** ZIP code **;
  
  %Octo_zip()
  
  label 
    CJRTRACTBL = "OCTO tract/block ID"
    Gis_id = "OCTO ZIP code ID"
    zipcode = "ZIP code"
    X = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    Y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  format x y 10.2;
  
  keep Geo2000 GeoBlk2000 Zip zipcode CJRTRACTBL Gis_id x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_Zip,
  by=GeoBlk2000,
  id=Zip
)

proc sort data=General.Block00_Zip nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_Zip, stats=, freqvars=Zip )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0zipf,
  Data=General.Block00_Zip,
  Value=GeoBlk2000,
  Label=Zip,
  OtherLabel="",
  Desc="Block 2000 to ZIP code correspondence",
  Print=N,
  Contents=Y
  )

