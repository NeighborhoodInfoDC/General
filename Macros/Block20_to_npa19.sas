/**************************************************************************
 Macro:    Block20_to_npa19
 Library:  general
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to NPA (2019).

 Modifications:
**************************************************************************/

%macro Block20_to_npa19( invar=geoblk2020, outvar=npa2019, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2npa19f. );
  
  label &outvar = "NPA (2019)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $npa19a.;
  %end;

%mend Block20_to_npa19;



