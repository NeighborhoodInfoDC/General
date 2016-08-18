/**************************************************************************
 Program:  GeoBlk2000.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/21/06
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  2000 Census block data set and formats.

 Modifications:
  07/10/12 PAT Add vars Geo2000, GeoBg2000, and City.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Census )

** Get list of tracts from NCDB **;

rsubmit;

data Census_blocks (compress=no);

  set Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000);
  
run;

proc download status=no
  data=Census_blocks 
  out=Census_blocks (compress=no);

run;

endrsubmit;

data General.GeoBlk2000 (label="List of DC census blocks (2000)");

  set Census_blocks;
  
  length block_num $ 30;
  
  block_num = trim( put( substr( geoblk2000, 1, 11 ), $geo00a. ) ) || ', block ' || 
              substr( geoblk2000, 12, 4 );
  
  label block_num = 'Census block (2000):  Tract tt.tt, block bbbb';
  
  %Geoblk2000_Octo()
  
  length Geo2000 $ 11 GeoBg2000 $ 12;
  
  Geo2000 = Geoblk2000;
  GeoBg2000 = Geoblk2000;

  label
    GeoBg2000 = 'Full census block group ID (2000): sscccttttttb'
    Geo2000 = 'Full census tract ID (2000): ssccctttttt';  

  ** Add City var **;

  length City $ 1;

  retain City "1";
  
  label City = "Washington, D.C.";
  
  format City $city.;

run;

proc sort data=General.GeoBlk2000;
  by GeoBlk2000;

run;

**** Create formats ****;

** $blk00a:  Tract tt.tt, block bbbb **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk00a,
  desc="Blocks (2000), 'Tract tt.tt, block bbbb'",
  Data=General.GeoBlk2000,
  Value=GeoBlk2000,
  Label=block_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $blk00v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk00v,
  Desc="Blocks (2000), validation",
  Data=General.GeoBlk2000,
  Value=GeoBlk2000,
  Label=GeoBlk2000,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $blk00so:  Convert standard (ssccctttttt) to OCTO format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk00so,
  Desc="Blocks (2000), standard to OCTO",
  Data=General.GeoBlk2000,
  Value=GeoBlk2000,
  Label=cjrTractBl,
  OtherLabel=' ',
  DefaultLen=30,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $blk00os:  Convert OCTO format to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk00os,
  Desc="Blocks (2000), OCTO to standard",
  Data=General.GeoBlk2000,
  Value=cjrTractBl,
  Label=GeoBlk2000,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=Y
  )

run;

proc catalog catalog=General.Formats;
  contents;
quit;

** Add formats to data set **;

proc datasets library=General nolist memtype=(data);
  modify GeoBlk2000;
    format geobg2000 $bg00a. geo2000 $geo00a. GeoBlk2000 $blk00a.;
quit;

%file_info( data=General.GeoBlk2000, printobs=40, stats= )

run;

signoff;
