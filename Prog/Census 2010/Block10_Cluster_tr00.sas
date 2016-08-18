/**************************************************************************
 Program:  Block10_Cluster_tr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Neighborhood Cluster (Cluster_tr2000) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_Cluster_tr00 
  (label="Census 2010 blocks (GeoBlk2010) to Tract-Based Neighborhood Cluster (Cluster_tr2000) correspondence file");

  set Cen2010m.Block10_Cluster_tr00;
  
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
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Cluster_tr2000 Tract BlkGrp Block NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_Cluster_tr00,
  by=GeoBlk2010,
  id=Cluster_tr2000
)

proc sort data=General.Block10_Cluster_tr00 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_Cluster_tr00, stats=, freqvars=Cluster_tr2000 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1ct0f,
  Data=General.Block10_Cluster_tr00,
  Value=GeoBlk2010,
  Label=Cluster_tr2000,
  OtherLabel="",
  Desc="Block 2010 to Nbr Clus (tract) 00 corres",
  Print=N,
  Contents=Y
  )

