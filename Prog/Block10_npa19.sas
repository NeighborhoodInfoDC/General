/************************************************************************
  Program:  Block10_npa19.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Eleanor Noble
  Created:  12/20/19
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2010 block to NPA 2019
  correspondence file.

  Adds correspondence format $bk1npa19f. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";


data Block10_NPA19 
  (label="Census 2010 blocks (GeoBlk2010) to Neighborhood Planning Areas (2019) correspondence file");

  set Cen2010m.Block10_npa19;
  
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
  %Octo_NPA2019()
  
  label 
    Gis_id = "OCTO NPA ID"
    NAME = "NPA code"
    Tract = "NPA tract ID"
    BlkGrp = "NPA block group ID"
    Block = "NPA block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 NPA2019 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block10_npa19,
  by=GeoBlk2010,
  id=npa2019
)

proc sort data=Block10_npa19 nodupkey;
  by GeoBlk2010;
run;


** Create correspondence format **;

%Data_to_format( 
  FmtLib=General,
  FmtName=$bk1npa19f,

  Data=Block10_NPA19,
  Value=GeoBlk2010,
  Label=NPA2019,
  OtherLabel="",
  Desc="Block 2010 to NPA 2019 corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block10_NPA19,
    out=Block10_NPA19,
    outlib=general,
    label="Census 2010 blocks (GeoBlk2010) to NPA 2019 (npa2019) correspondence file",
    sortby=GeoBlk2010,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

  /* End of program */
