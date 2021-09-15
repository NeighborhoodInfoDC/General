/**************************************************************************
 Program:  Block20_psa04.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/13/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Police Service Areas (PSA2004) correspondence file.

 Adds correspondence format $bk1ps4f. and $bk1pd4f. to local General library.

 Modifications: 2020 redistricting data; adds corresponse format $bk2ps4f. and $bk2pd4f
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_PSA04 
  (label="Census 2020 blocks (GeoBlk2020) to Police Service Areas (PSA2004) correspondence file");

  set Cen2020m.Block20_PSA04;

  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** PSA code **;
  
  %Octo_Psa2004(invar=Name_1)
  
  ** Police district code **;
  
  length PolDist2004 $ 2;
  
  PolDist2004 = POLDIST_ID;
    
  label 
    PolDist2004 = "MPD Police District (2004)"
    Gis_id = "OCTO PSA ID"
    NAME = "PSA code (number)"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Psa2004 PolDist2004 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;

%Dup_check(
  data=Block20_PSA04,
  by=GeoBlk2020,
  id=Psa2004
)

proc sort data=Block20_PSA04 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2ps4f,
  Data=Block20_PSA04,
  Value=GeoBlk2020,
  Label=Psa2004,
  OtherLabel="",
  Desc="Block 2020 to PSA 2004 correspondence",
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2pd4f,
  Data=Block20_PSA04,
  Value=GeoBlk2020,
  Label=PolDist2004,
  OtherLabel="",
  Desc="Block 2020 to PolDist 04 correspondence",
  Print=N,
  Contents=Y
  )

