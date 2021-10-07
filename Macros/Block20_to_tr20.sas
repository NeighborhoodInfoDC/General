/**************************************************************************
 Macro:    Block20_to_tr20
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 Census tracts (2020).

 Modifications:
**************************************************************************/

%macro Block20_to_tr20( invar=geoblk2020, outvar=Geo2020, format=Y );

  length &outvar $ 11;
  
  &outvar = left( &invar );
  
  label &outvar = "Full census tract ID (2020): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo20a.;
  %end;

%mend Block20_to_tr20;



