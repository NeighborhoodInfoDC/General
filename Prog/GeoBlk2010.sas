/**************************************************************************
 Program:  GeoBlk2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/19/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: 2010 Census block data set and formats.

 Modifications:
  07/09/12 PAT Added City var to file (needed for block-correspondence).
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

filename BlkPly  "&_dcdata_path\OCTO\Raw\BlockPly.csv" lrecl=256;

data GeoBlk2010;

  infile BlkPly dsd stopover firstobs=2;

  input
    Tract : $6.
    BlkGrp : $1.
    Block : $4.
    Shape_area
    Shape_len;

  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  length block_num $ 30;
  
  block_num = trim( put( substr( geoblk2010, 1, 11 ), $geo10a. ) ) || ', block ' || 
              substr( geoblk2010, 12, 4 );
  
  label
    tract = 'Census tract (2010): DC OCTO format: tttttt'
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt'
    Blkgrp = 'Census block group number (2010)'
    Block = 'Census block number (2010): bbbb'
    block_num = 'Census block (2010):  Tract tt.tt, block bbbb';

  ** Add City var **;

  length City $ 1;

  retain City "1";
  
  label City = "Washington, D.C.";
  
  format City $city.;

  drop Shape_: ;
  
run;

proc sort data=GeoBlk2010 out=General.GeoBlk2010 (label='List of DC census blocks (2010)');
  by GeoBlk2010;
run;


**** Create formats ****;

** $blk10a:  Tract tt.tt, block bbbb **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk10a,
  desc="Blocks (2010), 'Tract tt.tt, block bbbb'",
  Data=General.GeoBlk2010,
  Value=GeoBlk2010,
  Label=block_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N
  )

** $blk10v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$blk10v,
  Desc="Blocks (2010), validation",
  Data=General.GeoBlk2010,
  Value=GeoBlk2010,
  Label=GeoBlk2010,
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
  modify GeoBlk2010;
    format geobg2010 $bg10a. geo2010 $geo10a. GeoBlk2010 $blk10a.;
quit;

%File_info( data=General.GeoBlk2010, printobs=40, stats= )

