/**************************************************************************
 Program:  Block10_Cluster2017.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  12/08/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Neighborhood Cluster (Cluster2017) correspondence file.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data Block10_Cluster2017 
  (label="Census 2010 blocks (GeoBlk2010) to Neighborhood Cluster (Cluster2017) correspondence file");

  set Cen2010m.Block10_cluster2017;
  
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
  clusterID=substr(name,8,2);
  Gis_id = clusterID;
  %Octo_cluster2017()
  
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
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Cluster2017 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block10_Cluster2017,
  by=GeoBlk2010,
  id=Cluster2017
)

proc sort data=Block10_Cluster2017 nodupkey;
  by GeoBlk2010;
run;


** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1cl7f,

  Data=Block10_Cluster2017,
  Value=GeoBlk2010,
  Label=Cluster2017,
  OtherLabel="",
  Desc="Block 2010 to Nbrhd Cluster 2017 corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=block10_cluster2017,
    out=block10_cluster2017,
    outlib=general,
    label="Census 2010 blocks (GeoBlk2010) to cluster 2017 (cluster2017) correspondence file",
    sortby=GeoBlk2010,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
