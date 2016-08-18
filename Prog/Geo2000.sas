/**************************************************************************
 Program:  Geo2000.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/18/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  2000 Census tract list data set and formats.

 Modifications:
  01/27/06  Corrected $dc00geo format name.
  02/17/06  Revised conversion formats for OCTO & DC style tract names.
            Now draws NCDB data directly from Alpha library.
  10/20/09  Added new format geo00b.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )

** Get list of tracts from NCDB **;

rsubmit;

data Ncdb_tracts (compress=no);

  set Ncdb.Ncdb_lf_2000_dc (keep=geo2000);
  
run;

proc download status=no
  data=Ncdb_tracts 
  out=Ncdb_tracts (compress=no);

run;

endrsubmit;


data General.Geo2000 (label="List of DC census tracts (2000)");

  set Ncdb_tracts;
  
  length tract4_2 tract6 tract_dc $ 8 tract_num tract_octo $ 30;
  
  tract6 = left( substr( geo2000, 6, 6 ) );
  ntract = input( tract6, 6.2 );
  
  decpart = ntract - int( ntract );
  
  if 0 <= decpart <= 0.09 then
    tract4_2 = left( put( ntract, best. ) );
  else 
    tract4_2 = left( put( ntract, 7.2 ) );
  
  tract_num =  'Tract ' || tract4_2;

  ** DC tract identifiers **;
  
  ** NB:  Naming discrepency between DC/OCTO and census.  
  **      Census Tract 84.10 is called 84.01 by DC.;
  
  select ( geo2000 );
  
    when ( "11001008410" ) do;
      tract_dc = "84.01";
      tract_octo = "2000 Tract 84.01";
    end;
    
    otherwise do;
      tract_dc = left( put( int( ntract ) + ( 10 * ( ntract - int( ntract ) ) ), best. ) );
      tract_octo = '2000 Tract ' || tract4_2;
    end;

  end;
  
  label 
    tract6 = 'Census tract (2000):  tttttt'
    ntract = 'Census tract (2000):  numeric'
    tract4_2 = 'Census tract (2000):  tt.tt'
    tract_dc = 'Census tract (2000):  DC format:  tt.t'
    tract_octo = 'Census tract (2000):  DC OCTO Name:  2000 Tract tt.tt'
    tract_num = 'Census tract (2000):  Tract tt.tt'
  ;
  
  drop decpart;
  
run;

proc sort data=General.Geo2000;
  by Geo2000;

%file_info( data=General.Geo2000, printobs=190, stats= )

run;


**** Create formats ****;

** $geo00a:  Tract tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00a,
  Data=General.Geo2000,
  Value=Geo2000,
  Label=tract_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo00b:  tt.tt **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00b,
  Data=General.Geo2000,
  Value=Geo2000,
  Label=tract4_2,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo00so:  Convert standard (ssccctttttt) to OCTO (2000 Tract tt.tt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00so,
  Data=General.Geo2000,
  Value=Geo2000,
  Label=tract_octo,
  OtherLabel=' ',
  DefaultLen=30,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo00os:  Convert OCTO (2000 Tract tt.tt) to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00os,
  Data=General.Geo2000,
  Value=tract_octo,
  Label=Geo2000,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo00sd:  Convert standard (ssccctttttt) to DC format (tt.t) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00sd,
  Data=General.Geo2000,
  Value=Geo2000,
  Label=tract_dc,
  OtherLabel=' ',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo00ds:  Convert DC format (tt.t) to standard (ssccctttttt) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00ds,
  Data=General.Geo2000,
  Value=tract_dc,
  Label=Geo2000,
  OtherLabel=' ',
  DefaultLen=11,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $geo00v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$geo00v,
  Data=General.Geo2000,
  Value=Geo2000,
  Label=Geo2000,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify geo00a (desc="Tracts (2000), 'Tract tt.tt'");
  modify geo00b (desc="Tracts (2000), 'tt.tt'");
  modify geo00so (desc="Tracts (2000), Standard to OCTO");
  modify geo00os (desc="Tracts (2000), OCTO to standard");
  modify geo00sd (desc="Tracts (2000), Standard to DC");
  modify geo00ds (desc="Tracts (2000), DC to standard");
  modify geo00v (desc="Tracts (2000), validation");
  contents;
  quit;
  
** Add $geo00a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Geo2000;
    format geo2000 $geo00a.;
quit;

