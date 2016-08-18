/**************************************************************************
 Program:  Geo1990.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/05/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  1990 DC Census tract list data set and formats.

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

  set Ncdb.Ncdb_1990_dc (keep=Geo1990);
  
run;

proc download status=no
  data=Ncdb_tracts 
  out=Ncdb_tracts (compress=no);

run;

endrsubmit;


data General.Geo1990 (label="List of DC census tracts (1990)");

  set Ncdb_tracts;
  
  length tract4_2 tract6 $ 8 tract_num $ 30;
  
  tract6 = left( substr( Geo1990, 6, 6 ) );
  ntract = input( tract6, 6.2 );
  
  decpart = ntract - int( ntract );
  
  if 0 <= decpart <= 0.09 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );
  
  tract_num =  'Tract ' || tract4_2;

  label 
    tract6 = 'Census tract (1990):  tttttt'
    ntract = 'Census tract (1990):  numeric'
    tract4_2 = 'Census tract (1990):  tt.tt'
    tract_num = 'Census tract (1990):  Tract tt.tt'
  ;
  
  drop decpart;
  
run;

proc sort data=General.Geo1990;
  by Geo1990;

%file_info( data=General.Geo1990, printobs=190, stats= )

run;


**** Create formats ****;

** $geo90a:  Tract tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo90a,
  Data=General.Geo1990,
  Value=Geo1990,
  Label=tract_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo90v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo90v,
  Data=General.Geo1990,
  Value=Geo1990,
  Label=Geo1990,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify geo90a (desc="Tracts (1990), 'Tract tt.tt'");
  modify geo90v (desc="Tracts (1990), validation");
  contents;
  quit;
  
** Add $geo90a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Geo1990;
    format Geo1990 $geo90a.;
quit;

run;

signoff;

