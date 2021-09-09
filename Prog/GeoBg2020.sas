/**************************************************************************
 Program:  GeoBg2020.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/09/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  2020 Census block group data set and formats.

 Modifications: Updated for 2020 redistricting data
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

** Revisions to the file **;
%let revisions = Updated for 2020 redistricting data ;


** Combined metro BG data **;
data census_pl_2020_dmvw;
	set census.census_pl_2020_dc census.census_pl_2020_md
		census.census_pl_2020_va census.census_pl_2020_wv;
	if sumlev = "150";
	keep state county tract blkgrp;
run;



data GeoBg2020;
	set census_pl_2020_dmvw;

  length Geo2020 $ 11 GeoBg2020 $ 12;
  
  Geo2020 = state || county || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  
  label
    tract = 'Census tract (2020): DC OCTO format: tttttt'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt'
    Blkgrp = 'Census block group number (2020)';
  
  
run;


%Finalize_data_set( 
data=GeoBg2020,
out=GeoBg2020,
outlib=General,
label="List of DC, MD, VA, WV census block groups (2020)",
sortby=GeoBg2020,
restrictions=None,
revisions=%str(&revisions.)
);


**** Create formats ****;

** $bg20a:  Tract tt.tt, block bbbb **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bg20a,
  desc="Block groups (2020), 'Tract tt.tt, block group b'",
  Data=GeoBg2020,
  Value=GeoBg2020,
  Label=trim( put( Geo2020, $geo20a. ) ) || ', block group ' || Blkgrp,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $bg20v:  
** Validation format - returns block group number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bg20v,
  Desc="Block groups (2020), validation",
  Data=GeoBg2020,
  Value=GeoBg2020,
  Label=GeoBg2020,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

proc catalog catalog=general.formats;
  contents;
quit;

** Add formats to data set **;

proc datasets library=General nolist memtype=(data);
  modify GeoBg2020;
    format geobg2020 $bg20a. geo2020 $geo20a.;
quit;
