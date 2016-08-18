/**************************************************************************
 Program:  Block10_ANC02.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Advisory Neighborhood Commissions (ANC2002) correspondence file.

 Adds correspondence format $bk1an2f. to local General library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_ANC02 
  (label="Census 2010 blocks (GeoBlk2010) to Advisory Neighborhood Commissions (ANC2002) correspondence file");

  set Cen2010m.block10_anc02;

  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** ANC code **;
  
  %Octo_anc2002()

  label 
    Gis_id = "OCTO ANC ID"
    NAME = "ANC code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format Gis_id Name Tract BlkGrp Block ;
  informat _all_ ;
  
  keep anc2002 Tract BlkGrp Block gis_id geoblk2010 GeoBg2010 Geo2010 name;
  
run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_ANC02,
  by=GeoBlk2010,
  id=anc2002
)

proc sort data=General.Block10_ANC02 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_ANC02, stats=, freqvars=anc2002 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1an2f,
  Data=General.Block10_ANC02,
  Value=GeoBlk2010,
  Label=Anc2002,
  OtherLabel="",
  Desc="Block 2010 to ANC 2002 correspondence",
  Print=N,
  Contents=Y
  )

