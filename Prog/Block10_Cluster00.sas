/**************************************************************************
 Program:  Block10_Cluster00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Neighborhood Cluster (Cluster2000) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_Cluster00 
  (label="Census 2010 blocks (GeoBlk2010) to Neighborhood Cluster (Cluster2000) correspondence file");

  set Cen2010m.Block10_cluster00;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** Cluster code **;
  
  %Octo_cluster2000()
  
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
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Cluster2000 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_Cluster00,
  by=GeoBlk2010,
  id=Cluster2000
)

proc sort data=General.Block10_Cluster00 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_Cluster00, stats=, freqvars=Cluster2000 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1cl0f,
  Data=General.Block10_Cluster00,
  Value=GeoBlk2010,
  Label=Cluster2000,
  OtherLabel="",
  Desc="Block 2010 to Nbrhd Cluster 2000 corresp",
  Print=N,
  Contents=Y
  )

