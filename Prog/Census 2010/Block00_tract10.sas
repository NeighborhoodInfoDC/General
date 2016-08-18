/**************************************************************************
 Program:  Block00_tract10.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/12/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Census 2000 blocks (GeoBlk2000) to 
 Census 2010 tract (Geo2010) correspondence file.
 
 Creates correspondence format $bk1tr0f.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Octo )

*options obs=50;

data General.Block00_tract10 
  (label="Census 2000 blocks (GeoBlk2000) to Census 2010 tract (Geo2010) correspondence file");

  set Octo.Block00_tract10;
  
  ** Census block, block group, and tract IDs **;
  
  %Octo_GeoBlk2000( check=y )
  
  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

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
  
  keep GeoBlk2000 Geo2010 CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_tract10,
  by=GeoBlk2000,
  id=Geo2010
)

proc sort data=General.Block00_tract10 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_tract10, stats=, freqvars=Geo2010 )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0tr1f,
  Data=General.Block00_tract10,
  Value=GeoBlk2000,
  Label=Geo2010,
  OtherLabel="",
  Desc="Block 2000 to Tract 2010 correspondence",
  Print=N,
  Contents=Y
  )

