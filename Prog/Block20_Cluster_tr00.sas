/**************************************************************************
 Program:  Block20_Cluster_tr00.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/13/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Neighborhood Cluster (Cluster_tr2000) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Cluster_tr00 
  (label="Census 2020 blocks (GeoBlk2020) to Tract-Based Neighborhood Cluster (Cluster_tr2000) correspondence file");

  set Cen2020m.Block20_Cluster_tr00;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** Cluster code **;
  
  length Cluster_tr2000 $ 2;
  
  Cluster_tr2000 = cluster00;
  
  label 
    Cluster_tr2000 = "Neighborhood cluster (tract-based, 2000)"
    NAME = "Cluster code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Cluster_tr2000 Tract BlkGrp Block NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_Cluster_tr00,
  by=GeoBlk2020,
  id=Cluster_tr2000
)

proc sort data=Block20_Cluster_tr00 nodupkey;
  by GeoBlk2020;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2ct0f,
  Data=Block20_Cluster_tr00,
  Value=GeoBlk2020,
  Label=Cluster_tr2000,
  OtherLabel="",
  Desc="Block 2020 to Nbr Clus (tract) 00 corres",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
  data=Block20_Cluster_tr00,
  out=Block20_Cluster_tr00,
  outlib=general,
  label="Census 2020 blocks (GeoBlk2020) to neighborhood cluster (tract) 00 correspondence file",
  sortby=GeoBlk2020,
  /** Metadata parameters **/
  revisions=New file.,
  /** File info parameters **/
  printobs=5,
  freqvars=
  )
