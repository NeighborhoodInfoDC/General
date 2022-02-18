/************************************************************************
  Program:  Block00_Ward22.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  02/18/22
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2000 block to Ward (2022) 
  correspondence file.

  Adds correspondence format $bk0wdbf. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data Block00_Ward22 
  (label="Census 2000 blocks (GeoBlk2000) to Wards (Ward2022) correspondence file");

  set OCTO.Block00_ward22;
  
  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** Ward2012 var **;

  %Octo_Ward2022( check=y )
  
  label 
    Ward = "OCTO Ward ID"
    NAME = "OCTO Ward name"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 Ward2022 Ward NAME CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block00_Ward22,
  by=GeoBlk2000,
  id=Ward2022
)

proc sort data=Block00_Ward22 nodupkey;
  by GeoBlk2000;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0wdbf,
  Data=Block00_Ward22,
  Value=GeoBlk2000,
  Label=Ward2022,
  OtherLabel="",
  Desc="Block 2000 to Ward 2022 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block00_Ward22,
    out=Block00_Ward22,
    outlib=general,
    label="Wards (2022)""Census 2000 blocks (GeoBlk2000) to Wards (Ward2022) correspondence file",
    sortby=GeoBlk2000,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )
