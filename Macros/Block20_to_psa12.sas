/**************************************************************************
 Macro:    Block20_to_psa12
 Library:  
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC PSAs (2012).

 Modifications:
**************************************************************************/

%macro Block20_to_psa12( invar=geoblk2020, outvar=Psa2012, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk2psaf. );
  
  label &outvar = "Police Service Area (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa12a.;
  %end;

%mend Block20_to_psa12;



