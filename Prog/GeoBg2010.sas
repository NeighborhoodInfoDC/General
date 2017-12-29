/**************************************************************************
 Program:  GeoBg2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/19/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  2010 Census block group data set and formats.

 Modifications:
  RP 12/28/17 - Updated to run for entire Metro Area.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

** Revisions to the file **;
%let revisions = Added MD VA and WV tracts. ;


** Combined metro BG data **;
data census_pl_2010_dmvw;
	set census.census_pl_2010_dc census.census_pl_2010_md
		census.census_pl_2010_va census.census_pl_2010_wv;
	if sumlev = "150";
	keep state county tract blkgrp;
run;



data GeoBg2010;
	set census_pl_2010_dmvw;

  length Geo2010 $ 11 GeoBg2010 $ 12;
  
  Geo2010 = state || county || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  
  label
    tract = 'Census tract (2010): DC OCTO format: tttttt'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt'
    Blkgrp = 'Census block group number (2010)';
  
  
run;


%Finalize_data_set( 
data=GeoBg2010,
out=GeoBg2010,
outlib=General,
label="List of DC, MD, VA, WV census block groups (2010)",
sortby=GeoBg2010,
restrictions=None,
revisions=%str(&revisions.)
);


**** Create formats ****;

** $bg10a:  Tract tt.tt, block bbbb **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bg10a,
  desc="Block groups (2010), 'Tract tt.tt, block group b'",
  Data=General.GeoBg2010,
  Value=GeoBg2010,
  Label=trim( put( Geo2010, $geo10a. ) ) || ', block group ' || Blkgrp,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $bg10v:  
** Validation format - returns block group number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bg10v,
  Desc="Block groups (2010), validation",
  Data=General.GeoBg2010,
  Value=GeoBg2010,
  Label=GeoBg2010,
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
  modify GeoBg2010;
    format geobg2010 $bg10a. geo2010 $geo10a.;
quit;
