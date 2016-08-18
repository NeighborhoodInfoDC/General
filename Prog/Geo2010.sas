/**************************************************************************
 Program:  Geo2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/19/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create Census tract 2010 list and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

filename TractPly  "&_dcdata_path\OCTO\Raw\TractPly.csv" lrecl=256;

data Geo2010;

  infile TractPly dsd stopover firstobs=2;

  input
    Tract : $6.
    Shape_area
    Shape_len;

  length Tract6 $ 6;
  
  Tract6 = Tract;
  
  ntract = input( Tract6, 6.2 );

  length Geo2010 $ 11;
  
  Geo2010 = '11001' || Tract6;

  decpart = ntract - int( ntract );
  
  if 0 <= decpart < 0.095 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );
  
  tract_num =  'Tract ' || tract4_2;

  ** DC tract identifiers **;
  
  if 0 <= decpart < 0.095 and int( ntract ) ~= 98 then
    tract_dc = left( put( int( ntract ) + ( 10 * ( ntract - int( ntract ) ) ), best. ) );
  else 
    tract_dc = left( put( ntract, best. ) );

  label 
    geo2010 = 'Full census tract ID (2010): ssccctttttt'
    tract6 = 'Census tract (2010): tttttt'
    ntract = 'Census tract (2010): numeric'
    tract4_2 = 'Census tract (2010): tt.tt'
    tract_dc = 'Census tract (2010): DC format: tt.t'
    tract = 'Census tract (2010): DC OCTO format: tttttt'
    tract_num = 'Census tract (2010): Tract tt.tt'
  ;

  drop shape_: decpart;

run;

proc sort data=Geo2010 out=General.Geo2010 (label='List of DC census tracts (2010)');
  by Geo2010;
run;

%File_info( data=General.Geo2010, printobs=180, stats= )


**** Create formats ****;

** $geo10a:  Tract tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10a,
  Data=General.Geo2010,
  Value=Geo2010,
  Label=tract_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo10b:  tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10b,
  Data=General.Geo2010,
  Value=Geo2010,
  Label=tract4_2,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo10so:  Convert standard (ssccctttttt) to OCTO (tttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10so,
  Data=General.Geo2010,
  Value=Geo2010,
  Label=tract,
  OtherLabel=' ',
  DefaultLen=30,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo10os:  Convert OCTO (tttttt) to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10os,
  Data=General.Geo2010,
  Value=tract,
  Label=Geo2010,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo10sd:  Convert standard (ssccctttttt) to DC format (tt.t) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10sd,
  Data=General.Geo2010,
  Value=Geo2010,
  Label=tract_dc,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo10ds:  Convert DC format (tt.t) to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10ds,
  Data=General.Geo2010,
  Value=tract_dc,
  Label=Geo2010,
  OtherLabel=' ',
  DefaultLen=11,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo10v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo10v,
  Data=General.Geo2010,
  Value=Geo2010,
  Label=Geo2010,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify geo10a (desc="Tracts (2010), 'Tract tt.tt'");
  modify geo10b (desc="Tracts (2010), 'tt.tt'");
  modify geo10so (desc="Tracts (2010), Standard to OCTO");
  modify geo10os (desc="Tracts (2010), OCTO to standard");
  modify geo10sd (desc="Tracts (2010), Standard to DC");
  modify geo10ds (desc="Tracts (2010), DC to standard");
  modify geo10v (desc="Tracts (2010), validation");
  contents;
  quit;
  
** Add $geo10a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Geo2010;
    format geo2010 $geo10a.;
quit;

