/**************************************************************************
 Macro:    Fedtractno  (compatibility bundle)
 Library:  OCTO / Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian

 Description: Create FEDTRACTNO variable for matching census tract data
 to the OCTO tract shape file, from the 11-character Geo2000 tract ID.
 Handles the empty case and the special tract 84.10 explicitly, and
 otherwise reformats the 6-digit tract portion with a 6.2 informat.

 This bundle contains the %Fedtractno macro verbatim from
 Macros/Fedtractno.sas, followed by a caller exercising all three
 SELECT branches against sample Geo2000 tract IDs.
**************************************************************************/

/** Macro Fedtractno - verbatim from Macros/Fedtractno.sas **/

%macro Fedtractno( invar=Geo2000, outvar=Fedtractno );

  ** Var. for matching data with OCTO tract shape files **;

  length &outvar $ 16;

  select ( &invar );
    when ( '' )
      &outvar = '';
    when ( '11001008410' )
      &outvar = '84.01';
    otherwise
      &outvar = left( put( input( substr( &invar, 6, 6 ), 6.2 ), best16. ) );
  end;

  label &outvar = 'Census tract ID (2000) for matching with OCTO shape file';

%mend Fedtractno;

/** Caller: convert sample Geo2000 tract IDs to OCTO Fedtractno **/

data tracts;
  length Geo2000 $ 11;
  input Geo2000 $;
  %Fedtractno( invar=Geo2000, outvar=Fedtractno )
datalines;
11001000100
11001007301
11001009907
11001008410
;
run;

proc print data=tracts label;
  title "Fedtractno: Geo2000 tract ID to OCTO tract match key";
run;
