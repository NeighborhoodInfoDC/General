************************************************************************
* Program:  Block00_ANC02.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  02/08/05
* Version:  SAS 8.12
* Environment:  Windows
* 
* Description:  Create Census 2000 block to ANC (2002) file 
* from ArcGIS (DBF) source.
*
* NOTE:  Program requires DBMS/Engines
*
* Modifications:
*  03/30/06  Updated, added correspondence format.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

libname Octo_dbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4
  block="Block00_ANC02";

*options obs=50;

data General.Block00_ANC02 
  (label="Census 2000 blocks (GeoBlk2000) to Advisory Neighborhood Commissions (ANC2002) correspondence file");

  set Octo_dbf.block;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** ANC code **;
  
  %Octo_anc2002()

  label 
    CJRTRACTBL = "OCTO tract/block ID"
    Gis_id = "OCTO ANC ID"
    NAME = "ANC code"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove conflicting duplicate obs. **;

  if GEOBLK2000 = "110010068041004" and ANC2002 ~= "7D" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format CJRTRACTBL Gis_id Name;
  informat _all_ ;
  
  format x y 10.2;
  
  keep anc2002 cjrtractbl gis_id geo2000 geoblk2000 name x y;
  
run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_ANC02,
  by=GeoBlk2000,
  id=anc2002
)

proc sort data=General.Block00_ANC02 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_ANC02, stats=, freqvars=anc2002 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0an2f,
  Data=General.Block00_ANC02,
  Value=GeoBlk2000,
  Label=Anc2002,
  OtherLabel="",
  Desc="Block 2000 to ANC 2002 correspondence",
  Print=N,
  Contents=Y
  )

