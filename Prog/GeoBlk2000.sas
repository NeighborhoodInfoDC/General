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
  12/28/17  Updated to run for entire Metro Area. -RP
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%let revisions = Added MD VA and WV tracts. ;

** Get list of tracts from NCDB **;


data cen2000_sf1_all_blks;
	set Census.Cen2000_sf1_dc_blks Census.Cen2000_sf1_md_blks
	    Census.Cen2000_sf1_va_blks Census.Cen2000_sf1_wv_blks;
	keep state cnty GeoBlk2000;
run;


data GeoBlk2000 (label="List of DC census blocks (2000)");

  set cen2000_sf1_all_blks;
  
  length block_num $ 30;
  
  block_num = trim( put( substr( geoblk2000, 1, 11 ), $geo00a. ) ) || ', block ' || 
              substr( geoblk2000, 12, 4 );


  
  label block_num = 'Census block (2000):  Tract tt.tt, block bbbb';
  
  *%Geoblk2000_Octo();

  
  length Geo2000 $ 11 GeoBg2000 $ 12;
  
  Geo2000 = Geoblk2000;
  GeoBg2000 = Geoblk2000;

  label
    GeoBg2000 = 'Full census block group ID (2000): sscccttttttb'
    Geo2000 = 'Full census tract ID (2000): ssccctttttt';  


run;

%Finalize_data_set( 
data=GeoBlk2000,
out=GeoBlk2000,
outlib=General,
label="List of DC, MD, VA, WV census blocks (2000)",
sortby=GeoBlk2000,
restrictions=None,
revisions=%str(&revisions.)
);



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
  Data=General.GeoBlk2000 (where=(statecd="11")),
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
  Data=General.GeoBlk2000 (where=(statecd="11")),
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



