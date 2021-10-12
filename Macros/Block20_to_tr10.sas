/**************************************************************************
 Macro:    Block20_to_tr10
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 Census tracts (2010).

 Modifications:
**************************************************************************/

%macro Block20_to_tr10( invar=geoblk2020, outvar=Geo2010, format=Y );

  length &outvar $ 11;
  
  &outvar = put( &invar, $bk2tr1f. );
  
  label &outvar = "Full census tract ID (2010): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo10a.;
  %end;

%mend Block20_to_tr10;
