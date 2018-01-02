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
  12/28/17  Updated to run for entire Metro Area. -RP
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%let revisions = Added MD VA and WV tracts. ;


data cen2000_sf1_all_blks;
	set Census.Cen2000_sf1_dc_blks Census.Cen2000_sf1_md_blks
	    Census.Cen2000_sf1_va_blks Census.Cen2000_sf1_wv_blks;
	keep state cnty GeoBlk2000;
run;



** Get list of tracts from NCDB **;


data GeoBg2000;

  set cen2000_sf1_all_blks;

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


%Finalize_data_set( 
data=GeoBg2000,
out=GeoBg2000,
outlib=General,
label="List of DC, MD, VA, WV census block groups (2000)",
sortby=GeoBg2000,
restrictions=None,
revisions=%str(&revisions.)
);


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


