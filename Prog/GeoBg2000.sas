/**************************************************************************
 Program:  GeoBg2000.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/21/06
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  2000 Census block group data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Census )

** Get list of tracts from NCDB **;

rsubmit;

data GeoBg2000;

  set Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000);

  length GeoBg2000 $ 12;
  
  GeoBg2000 = left( GeoBlk2000 );
  
  label GeoBg2000 = 'Full census block group ID (2000): sscccttttttb';
  
  length Geo2000 $ 11;
  
  Geo2000 = GeoBg2000;
  
  label Geo2000 = 'Full census tract ID (2000): ssccctttttt';
  
  length Blkgrp $ 1;
  
  blkgrp = reverse( GeoBg2000 );
  
  label Blkgrp = 'Census block group number (2000)';
  
  keep GeoBg2000 Geo2000 Blkgrp;
  
run;

proc download status=no
  data=GeoBg2000 
  out=GeoBg2000 (compress=no);

run;

endrsubmit;

proc sort data=GeoBg2000 out=General.GeoBg2000 (label="List of DC census block groups (2000)") nodupkey;
  by GeoBg2000;

%file_info( data=General.GeoBg2000, printobs=40, stats= )

run;

**** Create formats ****;

** $bg00a:  Tract tt.tt, block bbbb **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bg00a,
  desc="Block groups (2000), 'Tract tt.tt, block group b'",
  Data=General.GeoBg2000,
  Value=GeoBg2000,
  Label=trim( put( Geo2000, $geo00a. ) ) || ', block group ' || Blkgrp,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $bg00v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bg00v,
  Desc="Block groups (2000), validation",
  Data=General.GeoBg2000,
  Value=GeoBg2000,
  Label=GeoBg2000,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

proc catalog catalog=general.formats;
  contents;
quit;

signoff;
