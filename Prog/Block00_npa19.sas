/************************************************************************
  Program:  Block00_npa19.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Eleanor Noble
  Created:  12/18/19
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2000 block to NPA 2019
  correspondence file.

  Adds correspondence format $bk0npa19f. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=5;

data block00_npa19
  (label="Census 2000 blocks (GeoBlk2000) to NPA2019 (npa2019) correspondence file");

  set OCTO.Block00_npa19;
  
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
  %Octo_npa2019( check=y )
  
  label 
    npa2019 = "NPA (2019)"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 npa2019 CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=block00_npa19,
  by=GeoBlk2000,
  id=npa2019
)

proc sort data=block00_npa19 nodupkey;
  by GeoBlk2000;
run;


%Data_to_format(
  FmtLib=General,
  FmtName=$bk0npa19f,
  Data=block00_npa19,
  Value=GeoBlk2000,
  Label=npa2019,
  OtherLabel="",
  Desc="Block 2000 to NPA 2019 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=block00_npa19,
    out=block00_npa19,
    outlib=general,
    label="Census 2000 blocks (GeoBlk2000) to NPA 2019 (NPA2019) correspondence file",
    sortby=GeoBlk2000,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

  /* End of program */
