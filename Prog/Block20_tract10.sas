/**************************************************************************
 Program:  Block20_tract10.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/14/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Census 2010 tract (Geo2010) correspondence file.
 
 Creates correspondence format $bk2tr0f.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_tract10 
  (label="Census 2020 blocks (GeoBlk2020) to Census 2010 tract (Geo2010) correspondence file");

  set Block20_tract10;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** Census 2010 tract **;
  
  length Geo2010 $ 11;
  
  Geo2010 = '11001' || Tract;
  
  label
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  label 
    ANC_ID = "OCTO ANC code"
    Name = "OCTO ANC name"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 Geo2010 CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_tract10,
  by=GeoBlk2020,
  id=Geo2010
)

proc sort data=Block20_tract10 nodupkey;
  by GeoBlk2020;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2tr1f,
  Data=Block20_tract10,
  Value=GeoBlk2020,
  Label=Geo2010,
  OtherLabel="",
  Desc="Block 2020 to Tract 2010 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_tract10,
    out=Block20_tract10,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to Tract 2010 correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

