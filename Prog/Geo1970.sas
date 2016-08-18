/**************************************************************************
 Program:  Geo1970.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/12/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  1970 DC Census tract list data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )

** Get list of tracts from NCDB **;

rsubmit;

data Ncdb_tracts (compress=no);

  set Ncdb.Ncdb_1970_dc (keep=Geo1970);
  
run;

proc download status=no
  data=Ncdb_tracts 
  out=Ncdb_tracts (compress=no);

run;

endrsubmit;


data General.Geo1970 (label="List of DC census tracts (1970)");

  set Ncdb_tracts;
  
  length tract4_2 tract6 $ 8 tract_num $ 30;
  
  tract6 = left( substr( Geo1970, 6, 6 ) );
  ntract = input( tract6, 6.2 );
  
  decpart = ntract - int( ntract );
  
  if 0 <= decpart <= 0.09 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );
  
  tract_num =  'Tract ' || tract4_2;

  label 
    tract6 = 'Census tract (1970):  tttttt'
    ntract = 'Census tract (1970):  numeric'
    tract4_2 = 'Census tract (1970):  tt.tt'
    tract_num = 'Census tract (1970):  Tract tt.tt'
  ;
  
  drop decpart;
  
run;

proc sort data=General.Geo1970;
  by Geo1970;

%file_info( data=General.Geo1970, printobs=190, stats= )

run;


**** Create formats ****;

** $geo70a:  Tract tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo70a,
  Data=General.Geo1970,
  Value=Geo1970,
  Label=tract_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo70v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo70v,
  Data=General.Geo1970,
  Value=Geo1970,
  Label=Geo1970,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify geo70a (desc="Tracts (1970), 'Tract tt.tt'");
  modify geo70v (desc="Tracts (1970), validation");
  contents;
  quit;
  
** Add $geo70a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Geo1970;
    format Geo1970 $geo70a.;
quit;

run;

signoff;

