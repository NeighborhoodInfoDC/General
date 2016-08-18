/**************************************************************************
 Program:  Block10_ward02.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Wards (Ward2002) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_Ward02 
  (label="Census 2010 blocks (GeoBlk2010) to Wards (Ward2002) correspondence file");

  set Cen2010m.Block10_ward02;

  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** Ward code **;
  
  %Octo_ward2002()
  
  label 
    Gis_id = "OCTO Ward ID"
    NAME = "Ward code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove conflicting duplicate obs. **;

  ***if GeoBlk2010 = "110010068041004" and Ward2002 ~= "7" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Ward2002 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_Ward02,
  by=GeoBlk2010,
  id=Ward2002
)

proc sort data=General.Block10_Ward02 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_Ward02, stats=, freqvars=Ward2002 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1wd2f,
  Data=General.Block10_Ward02,
  Value=GeoBlk2010,
  Label=Ward2002,
  OtherLabel="",
  Desc="Block 2010 to Ward 2002 correspondence",
  Print=N,
  Contents=Y
  )

