/**************************************************************************
 Program:  Geo2020.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/09/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create Census tract 2020 list and formats.

 Modifications: Updated for 2020 redistricting data
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )


** Revisions to the file **;
%let revisions = Added MD VA and WV tracts. ;


** Combined metro area tract data **;
data census_pl_2020_dmvw;
	set census.census_pl_2020_dc census.census_pl_2020_md
		census.census_pl_2020_va census.census_pl_2020_wv;
	if sumlev = "140";
	keep state county tract;
run;


data Geo2020;
	set census_pl_2020_dmvw;

  length Tract6 $ 6;
  
  Tract6 = Tract;
  
  ntract = input( Tract6, 6.2 );

  length Geo2020 $ 11;
  
  Geo2020 = state || county || Tract6;

  decpart = ntract - int( ntract );
  
  if 0 <= decpart < 0.095 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );

  if state = '11' then tract_num =  'DC Tract ' || tract4_2;
  else if state = '24' then tract_num =  'MD Tract ' || county || ' ' || tract4_2;
  else if state = '51' then tract_num =  'VA Tract ' || county || ' ' || tract4_2;
  else if state = '54' then tract_num =  'WV Tract ' || county || ' ' || tract4_2;

  ** DC tract identifiers **;
  
  if 0 <= decpart < 0.095 and int( ntract ) ~= 98 then
    tract_dc = left( put( int( ntract ) + ( 10 * ( ntract - int( ntract ) ) ), best. ) );
  else 
    tract_dc = left( put( ntract, best. ) );

  label 
    geo2020 = 'Full census tract ID (2020): ssccctttttt'
    tract6 = 'Census tract (2020): tttttt'
    ntract = 'Census tract (2020): numeric'
    tract4_2 = 'Census tract (2020): tt.tt'
    tract_dc = 'Census tract (2020): DC format: tt.t'
    tract = 'Census tract (2020): DC OCTO format: tttttt'
    tract_num = 'Census tract (2020): [State] Tract tt.tt'
  ;

  drop decpart;

run;


%Finalize_data_set( 
data=Geo2020,
out=Geo2020,
outlib=General,
label="List of DC, MD, VA, WV census tracts (2020)",
sortby=Geo2020,
restrictions=None,
revisions=%str(&revisions.)
);


**** Create formats ****;

** $geo20a:  Tract tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20a,
  Data=Geo2020,
  Value=Geo2020,
  Label=tract_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo20b:  tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20b,
  Data=Geo2020,
  Value=Geo2020,
  Label=tract4_2,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo20so:  Convert standard (ssccctttttt) to OCTO (tttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20so,
  Data=Geo2020 (where=(state="11")),
  Value=Geo2020,
  Label=tract,
  OtherLabel=' ',
  DefaultLen=30,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo20os:  Convert OCTO (tttttt) to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20os,
  Data=Geo2020 (where=(state="11")),
  Value=tract,
  Label=Geo2020,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo20sd:  Convert standard (ssccctttttt) to DC format (tt.t) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20sd,
  Data=Geo2020 (where=(state="11")),
  Value=Geo2020,
  Label=tract_dc,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo20ds:  Convert DC format (tt.t) to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20ds,
  Data=Geo2020 (where=(state="11")),
  Value=tract_dc,
  Label=Geo2020,
  OtherLabel=' ',
  DefaultLen=11,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo20v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo20v,
  Data=Geo2020,
  Value=Geo2020,
  Label=Geo2020,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify geo20a (desc="Tracts (2020), 'Tract tt.tt'");
  modify geo20b (desc="Tracts (2020), 'tt.tt'");
  modify geo20so (desc="Tracts (2020), Standard to OCTO");
  modify geo20os (desc="Tracts (2020), OCTO to standard");
  modify geo20sd (desc="Tracts (2020), Standard to DC");
  modify geo20ds (desc="Tracts (2020), DC to standard");
  modify geo20v (desc="Tracts (2020), validation");
  contents;
  quit;
  
** Add $geo20a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Geo2020;
    format geo2020 $geo20a.;
quit;

