/************************************************************************
  Program:  Block00_psa19.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Rob Pitingolo
  Created:  12/05/19
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2000 block to PSA 2019
  correspondence file.

  Adds correspondence format $bk0ps9f. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data block00_psa19
  (label="Census 2000 blocks (GeoBlk2000) to PSA2019 (psa2019) correspondence file");

  set OCTO.Block00_psa19;
  
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
  %Octo_Psa2019( check=y )
  
  label 
    psa2019 = "PSA (2019)"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 psa2019 CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=block00_psa19,
  by=GeoBlk2000,
  id=psa2019
)

proc sort data=block00_psa19 nodupkey;
  by GeoBlk2000;
run;


%Data_to_format(
  FmtLib=General,
  FmtName=$bk0ps9f,
  Data=block00_psa19,
  Value=GeoBlk2000,
  Label=psa2019,
  OtherLabel="",
  Desc="Block 2000 to PSA 2019 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=block00_psa19,
    out=block00_psa19,
    outlib=general,
    label="Census 2000 blocks (GeoBlk2000) to PSA 2019 (psa2019) correspondence file",
    sortby=GeoBlk2000,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

  /* End of program */
