/**************************************************************************
 Macro:    Block20_to_stantoncommons
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to Stanton Commons geography.

 Modifications:
**************************************************************************/

%macro Block20_to_stantoncommons( invar=geoblk2020, outvar=stantoncommons, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2stanc. );
  
  label &outvar = "Stanton Commons (2018)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $stanca.;
  %end;

%mend Block20_to_stantoncommons;



