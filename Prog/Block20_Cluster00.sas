/**************************************************************************
 Program:  Block20_Cluster00.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/13/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Neighborhood Cluster (Cluster2000) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Cluster00 
  (label="Census 2020 blocks (GeoBlk2020) to Neighborhood Cluster (Cluster2000) correspondence file");

  set Cen2020m.Block20_cluster00;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = substr(geoid,10,11);
  GeoBg2020 = substr(geoid,10,12);
  GeoBlk2020 = substr(geoid,10,15);
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** Cluster code **;
  
  %Octo_cluster2000(invar=name_1)
  
  label 
    Gis_id = "OCTO Cluster ID"
    NAME = "Cluster code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Cluster2000 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_Cluster00,
  by=GeoBlk2020,
  id=Cluster2000
)

proc sort data=Block20_Cluster00 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$Bk2cl0f,
  Data=Block20_Cluster00,
  Value=GeoBlk2020,
  Label=Cluster2000,
  OtherLabel="",
  Desc="Block 2020 to Nbrhd Cluster 2000 corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
  data=Block20_Cluster00,
  out=Block20_Cluster00,
  outlib=general,
  label="Census 2020 blocks (GeoBlk2020) to neighborhood cluster 2000 correspondence file",
  sortby=GeoBlk2020,
  /** Metadata parameters **/
  revisions=New file.,
  /** File info parameters **/
  printobs=5,
  freqvars=
  )

