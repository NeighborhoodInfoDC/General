/**************************************************************************
 Macro:    Block10_to_stantoncommons
 Library:  Macros
 Project:  Stanton Commons
 Author:   Yipeng Su
 Created:  3/17/2018
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to Stanton Commons geography.

 Modifications:
**************************************************************************/

%macro Block10_to_stantoncommons( invar=geoblk2010, outvar=stantoncommons, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1stanc. );
  
  label &outvar = "Stanton Commons (2018)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $stanca.;
  %end;

%mend Block10_to_stantoncommons;



