/**************************************************************************
 Program:  Block10_psa04.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Police Service Areas (PSA2004) correspondence file.

 Adds correspondence format $bk1ps4f. and $bk1pd4f. to local General library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_PSA04 
  (label="Census 2010 blocks (GeoBlk2010) to Police Service Areas (PSA2004) correspondence file");

  set Cen2010m.Block10_PolSA04;

  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** PSA code **;
  
  %Octo_Psa2004()
  
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
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Psa2004 PolDist2004 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;

%Dup_check(
  data=General.Block10_PSA04,
  by=GeoBlk2010,
  id=Psa2004
)

proc sort data=General.Block10_PSA04 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_PSA04, stats=, freqvars=PolDist2004 PSA2004 )

run;

** Create correspondence formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1ps4f,
  Data=General.Block10_PSA04,
  Value=GeoBlk2010,
  Label=Psa2004,
  OtherLabel="",
  Desc="Block 2010 to PSA 2004 correspondence",
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1pd4f,
  Data=General.Block10_PSA04,
  Value=GeoBlk2010,
  Label=PolDist2004,
  OtherLabel="",
  Desc="Block 2010 to PolDist 04 correspondence",
  Print=N,
  Contents=Y
  )

