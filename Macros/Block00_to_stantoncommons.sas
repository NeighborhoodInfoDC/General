/**************************************************************************
 Macro:    Block00_to_cluster17
 Library:  
 Project:  Stanton Commons
 Author:   Yipeng Su
 Created:  3/15/2018
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to Stanton Commons ID.

 Modifications:
**************************************************************************/

%macro Block00_to_stantoncommons( invar=geoblk2000, outvar=stantoncommons, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0stanc. );
  
  label &outvar = "Stanton Commons (2018) ";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $stanca.;
  %end;

%mend Block00_to_stantoncommons;



