/**************************************************************************
 Macro:    Block20_to_psa19
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to PSA (2019).

 Modifications:
**************************************************************************/

%macro Block20_to_psa19( invar=geoblk2020, outvar=psa2019, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk2ps9f. );
  
  label &outvar = "PSA (2019)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa19a.;
  %end;

%mend Block20_to_psa19;



