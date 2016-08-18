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
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

filename BGPly  "&_dcdata_path\OCTO\Raw\BlockGroupPly.csv" lrecl=256;

data GeoBg2010;

  infile BGPly dsd stopover firstobs=2;

  input
    Tract : $6.
    BlkGrp : $1.
    Shape_area
    Shape_len;

  length Geo2010 $ 11 GeoBg2010 $ 12;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  
  label
    tract = 'Census tract (2010): DC OCTO format: tttttt'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt'
    Blkgrp = 'Census block group number (2010)';
  
  drop Shape_: ;
  
run;

proc sort data=GeoBg2010 out=General.GeoBg2010 (label='List of DC census block groups (2010)');
  by GeoBg2010;
run;

%File_info( data=General.GeoBg2010, printobs=40, stats= )

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
