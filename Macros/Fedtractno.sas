/**************************************************************************
 Macro:    Fedtractno
 Library:  OCTO
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/18/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Create FEDTRACTNO variable for
 matching census tract data to OCTO tract shape file.

 Modifications:
  01/24/07  Corrected problem with tract 84.10.
            Added invar= and outvar= parameters.
**************************************************************************/

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



