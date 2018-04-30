/************************************************************************
  Program:  Block00_stantoncommons.sas
  Library:  General
  Project:  Stanton Commons
  Author:   Yipeng Su
  Created:  3/17/2018
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2000 block to stantoncommons
  correspondence file.

  Adds correspondence format $bk0stanc. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data block00_stantoncommons
  (label="Census 2000 blocks (GeoBlk2000) to Stanton Commons (stantoncommons) correspondence file");

  set OCTO.Block00_stantoncommons;
  
  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** stantoncommons var **;
  %octo_stantoncommons( check=y )
  
  label 
    stantoncommons = "StantonCommons ID"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 stantoncommons CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block00_stantoncommons,
  by=GeoBlk2000,
  id=stantoncommons
)

proc sort data=Block00_stantoncommons nodupkey;
  by GeoBlk2000;
run;


%Data_to_format(
  FmtLib=General,
  FmtName=$bk0stanc,
  Data=Block00_stantoncommons,
  Value=GeoBlk2000,
  Label=stantoncommons,
  OtherLabel="",
  Desc="Block 2000 to Stanton Commons 2018 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=block00_stantoncommons,
    out=block00_stantoncommons,
    outlib=general,
    label="Census 2000 blocks (GeoBlk2000) to Stanton Commons (stantoncommons) correspondence file",
    sortby=GeoBlk2000,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
