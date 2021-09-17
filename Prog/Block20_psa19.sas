/************************************************************************
  Program:  Block20_psa19.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/13/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2020 block to PSA 2019
  correspondence file.

  Adds correspondence format $bk1ps9f. to local General library.

  Modifications: Added 2020 redistricting data; Adds correspondence format $bk2ps9f.
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";


data Block20_PSA19 
  (label="Census 2020 blocks (GeoBlk2020) to Neighborhood Cluster (Cluster2017) correspondence file");

  set Cen2020m.Block20_psa19;
  
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
  %Octo_Psa2019(invar=name_1)
  
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
  
  keep GeoBlk2020 GeoBg2020 Geo2020 PSA2019 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_PSA19,
  by=GeoBlk2020,
  id=psa2019
)

proc sort data=Block20_PSA19 nodupkey;
  by GeoBlk2020;
run;


** Create correspondence format **;

%Data_to_format( 
  FmtLib=General,
  FmtName=$bk2ps9f,
  Data=Block20_PSA19,
  Value=GeoBlk2020,
  Label=psa2019,
  OtherLabel="",
  Desc="Block 2020 to PSA 2019 corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_PSA19,
    out=Block20_PSA19,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to PSA 2019 (psa2019) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

  /* End of program */
