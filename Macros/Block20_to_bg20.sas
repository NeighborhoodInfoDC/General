/**************************************************************************
 Macro:    Block20_to_bg20
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 block groups (2020).

 Modifications:
**************************************************************************/

%macro Block20_to_bg20( invar=geoblk2020, outvar=GeoBg2020, format=Y );

  length &outvar $ 12;
  
  &outvar = left( &invar );
  
  label &outvar = "Full census block group ID (2020): sscccttttttb";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $bg20a.;
  %end;

%mend Block20_to_bg20;



