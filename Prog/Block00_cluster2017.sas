/************************************************************************
  Program:  Block00_cluster2017.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Yipeng Su
  Created:  12/07/17
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2000 block to cluster 2017
  correspondence file.

  Adds correspondence format $bk0cl7f. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.block00_cluster2017
  (label="Census 2000 blocks (GeoBlk2000) to cluster 2017 (cluster2017) correspondence file");

  set OCTO.Block00_cluster2017;
  
  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** cluster2017 var **;
clusterID=substr(name,8,2);
  %octo_cluster2017( check=y )
  
  label 
    cluster2017 = "Cluster ID"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 clusterID cluster2017 CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_cluster2017,
  by=GeoBlk2000,
  id=cluster2017
)

proc sort data=General.Block00_cluster2017 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_cluster2017, stats=, freqvars=cluster2017  )

/*
** Delete old formats **;

proc catalog catalog=General.Formats;
  delete bk0wdaf bk0wdbf / entrytype=formatc;
quit;
*/

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0cl7f.
,
  Data=General.Block00_cluster2017,
  Value=GeoBlk2000,
  Label=cluster2017,
  OtherLabel="",
  Desc="Block 2000 to cluster 2017 correspondence",
  Print=N,
  Contents=Y
  )

