/**************************************************************************
 Macro:    Fedtractno_geo2000
 Library:  OCTO
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/09/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Fedtractno in OCTO tract
 shapefile to standard Geo2000 tract ID.

 Modifications:
  01/24/07  Corrected problem with tract 84.10.
            Added invar= and outvar= parameters.
  12/13/12 PAT Added validation test - only valid 2000 tracts are saved
               to outvar, otherwise output value is missing (blank).
**************************************************************************/

%macro Fedtractno_geo2000( outvar=Geo2000, invar=Fedtractno );

  length &outvar $ 11;
  
  select ( &invar );
    when ( '' )
      &outvar = '';
    when ( '84.01' )
      &outvar = '11001008410';
    otherwise
      &outvar = put( "11001" || put( 100 * input( &invar, 16. ), z6. ), $geo00v. );
  end;

  label &outvar = "Full census tract ID (2000): ssccctttttt";

%mend Fedtractno_geo2000;



