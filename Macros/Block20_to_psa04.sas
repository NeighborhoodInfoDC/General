/**************************************************************************
 Macro:    Block20_to_psa04
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC PSAs (2004).

 Modifications:
**************************************************************************/

%macro Block20_to_psa04( invar=geoblk2020, outvar=Psa2004, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk2ps4f. );
  
  label &outvar = "Police Service Area (2004)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa04a.;
  %end;

%mend Block20_to_psa04;



