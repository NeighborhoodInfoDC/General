/************************************************************************
  Program:  Block00_ANC23.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Rob Pitingolo
  Created:  05/01/25
  Version:  SAS 9.4
  Environment:  Windows 11
  
  Description:  Create Census 2000 block to ANC (2023) 
  correspondence file.

  Adds correspondence format $bk0an3f. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
libname Cen "&_dcdata_path\General\Maps\";

*options obs=50;

data Block00_ANC23 
  (label="Census 2000 blocks (GeoBlk2000) to Advisory Neighborhood Commissions (Anc2023) correspondence file");

  set Cen.Block00_anc23;
  
  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** ANC 2023 var **;

  %Octo_Anc2023( invar=ANC_ID, check=y )
  
  label 
    ANC_ID = "OCTO ANC ID"
    NAME = "OCTO ANC name"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;

  ** Fix inconsistent duplicate block **;
  if GeoBlk2000 = "110010072001000" then Anc2023 = "8F";
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 Anc2023 ANC_ID NAME CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block00_ANC23,
  by=GeoBlk2000,
  id=Anc2023
)

proc sort data=Block00_ANC23 nodupkey;
  by GeoBlk2000;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0an3f,
  Data=Block00_ANC23,
  Value=GeoBlk2000,
  Label=Anc2023,
  OtherLabel="",
  Desc="Block 2000 to ANC 2023 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block00_ANC23,
    out=Block00_ANC23,
    outlib=general,
    label="Census 2000 blocks (GeoBlk2000) to Advisory Neighborhood Commissions (Anc2023) correspondence file",
    sortby=GeoBlk2000,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )
