/**************************************************************************
 Program:  Block10_zip.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 ZIP codes (ZIP) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_Zip 
  (label="Census 2010 blocks (GeoBlk2010) to ZIP codes correspondence file");

  set Cen2010m.block10_zip;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** ZIP code **;
  
  %Octo_zip()
  
  label 
    Gis_id = "OCTO ZIP code ID"
    zipcode = "ZIP code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Zip zipcode Tract BlkGrp Block Gis_id;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_Zip,
  by=GeoBlk2010,
  id=Zip
)

proc sort data=General.Block10_Zip nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_Zip, stats=, freqvars=Zip )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1zipf,
  Data=General.Block10_Zip,
  Value=GeoBlk2010,
  Label=Zip,
  OtherLabel="",
  Desc="Block 2010 to ZIP code correspondence",
  Print=N,
  Contents=Y
  )

