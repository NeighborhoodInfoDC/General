/**************************************************************************
 Program:  Block00_Zip_b.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/22/13
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Add GeoBg2000 variable to file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

data General.Block00_Zip 
  (label="Census 2000 blocks (GeoBlk2000) to ZIP codes correspondence file");

  set General.Block00_Zip;
  
  length GeoBg2000 $ 12;
  
  GeoBg2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb";

run;

%File_info( data=General.Block00_Zip )

