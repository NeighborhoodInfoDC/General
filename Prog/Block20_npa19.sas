/************************************************************************
  Program:  Block20_npa19.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/13/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2020 block to NPA 2019
  correspondence file.

  Adds correspondence format $bk2npa19f. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";


data Block20_NPA19 
  (label="Census 2020 blocks (GeoBlk2020) to Neighborhood Planning Areas (2019) correspondence file");

  set Cen2020m.Block20_npa19;
  
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
  %Octo_NPA2019(invar=OBJECTID_2)
  
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
  
  keep GeoBlk2020 GeoBg2020 Geo2020 NPA2019 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_npa19,
  by=GeoBlk2020,
  id=npa2019
)

proc sort data=Block20_npa19 nodupkey;
  by GeoBlk2020;
run;


** Create correspondence format **;

%Data_to_format( 
  FmtLib=General,
  FmtName=$bk2npa19f,
  Data=Block20_NPA19,
  Value=GeoBlk2020,
  Label=NPA2019,
  OtherLabel="",
  Desc="Block 2020 to NPA 2019 corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_NPA19,
    out=Block20_NPA19,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to NPA 2019 (npa2019) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

  /* End of program */
