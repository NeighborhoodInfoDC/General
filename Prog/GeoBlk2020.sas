/**************************************************************************
 Program:  GeoBlk2020.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/09/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: 2020 Census block data set and formats.

 Modifications: Updated for 2020 redistricting data
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )


** Revisions to the file **;
%let revisions = Updated for 2020 redistricting data ;


** Combined metro area tract data **;
data census_pl_2020_dmvw;
	set census.census_pl_2020_dc census.census_pl_2020_md
		census.census_pl_2020_va census.census_pl_2020_wv;
	if sumlev = "750";
	keep state county tract blkgrp block;
run;


data GeoBlk2020;
	set census_pl_2020_dmvw;

  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = state || county || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  length block_num $ 30;
  
  block_num = trim( put( substr( geoblk2020, 1, 11 ), $geo20a. ) ) || ', block ' || 
              substr( geoblk2020, 12, 4 );
  
  label
    tract = 'Census tract (2020): DC OCTO format: tttttt'
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt'
    Blkgrp = 'Census block group number (2020)'
    Block = 'Census block number (2020): bbbb'
    block_num = 'Census block (2020):  Tract tt.tt, block bbbb';
  
run;


%Finalize_data_set( 
data=GeoBlk2020,
out=GeoBlk2020,
outlib=General,
label="List of DC, MD, VA, WV census blocks (2020)",
sortby=GeoBlk2020,
restrictions=None,
revisions=%str(&revisions.)
);


**** Create formats ****;

** $blk20a:  Tract tt.tt, block bbbb **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk20a,
  desc="Blocks (2020), 'Tract tt.tt, block bbbb'",
  Data=GeoBlk2020,
  Value=GeoBlk2020,
  Label=block_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $blk20v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk20v,
  Desc="Blocks (2020), validation",
  Data=GeoBlk2020,
  Value=GeoBlk2020,
  Label=GeoBlk2020,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

run;

proc catalog catalog=General.Formats;
  contents;
quit;

** Add formats to data set **;

proc datasets library=General nolist memtype=(data);
  modify GeoBlk2020;
    format geobg2020 $bg20a. geo2020 $geo20a. GeoBlk2020 $blk20a.;
quit;



