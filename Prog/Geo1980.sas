/**************************************************************************
 Program:  Geo1980.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/05/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  1980 DC Census tract list data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General )
%DCData_lib( NCDB )

** Get list of tracts from NCDB **;

rsubmit;

data Ncdb_tracts (compress=no);

  set Ncdb.Ncdb_1980_dc (keep=Geo1980);
  
  ** REMOVE EXTRANEOUS TRACT **;
  
  if geo1980 = "11001007299" then delete;
  
run;

proc download status=no
  data=Ncdb_tracts 
  out=Ncdb_tracts (compress=no);

run;

endrsubmit;


data General.Geo1980 (label="List of DC census tracts (1980)");

  set Ncdb_tracts;
  
  length tract4_2 tract6 $ 8 tract_num $ 30;
  
  tract6 = left( substr( Geo1980, 6, 6 ) );
  ntract = input( tract6, 6.2 );
  
  decpart = ntract - int( ntract );
  
  if 0 <= decpart <= 0.09 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );
  
  tract_num =  'Tract ' || tract4_2;

  label 
    tract6 = 'Census tract (1980):  tttttt'
    ntract = 'Census tract (1980):  numeric'
    tract4_2 = 'Census tract (1980):  tt.tt'
    tract_num = 'Census tract (1980):  Tract tt.tt'
  ;
  
  drop decpart;
  
run;

proc sort data=General.Geo1980;
  by Geo1980;

%file_info( data=General.Geo1980, printobs=190, stats= )

run;


**** Create formats ****;

** $geo80a:  Tract tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo80a,
  Data=General.Geo1980,
  Value=Geo1980,
  Label=tract_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo80v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo80v,
  Data=General.Geo1980,
  Value=Geo1980,
  Label=Geo1980,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify geo80a (desc="Tracts (1980), 'Tract tt.tt'");
  modify geo80v (desc="Tracts (1980), validation");
  contents;
  quit;
  
** Add $geo80a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Geo1980;
    format Geo1980 $geo80a.;
quit;

run;

signoff;

