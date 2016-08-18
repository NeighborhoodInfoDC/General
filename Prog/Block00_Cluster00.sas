************************************************************************
* Program:  Block00_Cluster00.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  03/30/06
* Version:  SAS 8.12
* Environment:  Windows
* 
* Description:  Create Census 2000 block to Neighborhood Cluster (2002)
* file from ArcGIS (DBF) source.
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
  block="Block00_Cluster00";

*options obs=50;

data General.Block00_Cluster00 
  (label="Census 2000 blocks (GeoBlk2000) to Neighborhood Cluster (Cluster2000) correspondence file");

  set Octo_dbf.block;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** Cluster code **;
  
  %Octo_cluster2000()
  
  label 
    CJRTRACTBL = "OCTO tract/block ID"
    Gis_id = "OCTO Cluster ID"
    NAME = "Cluster code"
    X = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    Y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove conflicting duplicate obs. **;

  if geoblk2000 = "110010072001000" and cluster2000 ~= "27" then delete;

  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  format x y 10.2;
  
  keep Geo2000 GeoBlk2000 Cluster2000 CJRTRACTBL Gis_id NAME x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_Cluster00,
  by=GeoBlk2000,
  id=Cluster2000
)

proc sort data=General.Block00_Cluster00 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_Cluster00, stats=, freqvars=Cluster2000 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0cl0f,
  Data=General.Block00_Cluster00,
  Value=GeoBlk2000,
  Label=Cluster2000,
  OtherLabel="",
  Desc="Block 2000 to Nbrhd Cluster 2000 corresp",
  Print=N,
  Contents=Y
  )

