/**************************************************************************
 Program:  Geo2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/19/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create Census tract 2010 list and formats.

 Modifications: RP 12/28/17 - Updated to run for entire Metro Area.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )


** Revisions to the file **;
%let revisions = Added MD VA and WV tracts. ;


** Combined metro area tract data **;
data census_pl_2010_dmvw;
	set census.census_pl_2010_dc census.census_pl_2010_md
		census.census_pl_2010_va census.census_pl_2010_wv;
	if sumlev = "140";
	keep state county tract;
run;


data Geo2010;
	set census_pl_2010_dmvw;

  length Tract6 $ 6;
  
  Tract6 = Tract;
  
  ntract = input( Tract6, 6.2 );

  length Geo2010 $ 11;
  
  Geo2010 = state || county || Tract6;

  decpart = ntract - int( ntract );
  
  if 0 <= decpart < 0.095 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );

  if state = '11' then tract_num =  'DC Tract ' || tract4_2;
  else if state = '24' then tract_num =  'MD Tract ' || county || tract4_2;
  else if state = '51' then tract_num =  'VA Tract ' || county || tract4_2;
  else if state = '54' then tract_num =  'WV Tract ' || county || tract4_2;

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
    tract_num = 'Census tract (2010): [State] Tract tt.tt'
  ;

  drop decpart;

run;


%Finalize_data_set( 
data=Geo2010,
out=Geo2010,
outlib=General,
label="List of DC, MD, VA, WV census tracts (2010)",
sortby=Geo2010,
restrictions=None,
revisions=%str(&revisions.)
);


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
  Data=General.Geo2010 (where=(state="11")),
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
  Data=General.Geo2010 (where=(state="11")),
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
  Data=General.Geo2010 (where=(state="11")),
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
  Data=General.Geo2010 (where=(state="11")),
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

