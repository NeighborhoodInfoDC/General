/**************************************************************************
 Macro:    Block20_to_anc12
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC ANCs (2012).

 Modifications:
**************************************************************************/

%macro Block20_to_anc12( invar=geoblk2020, outvar=Anc2012, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk2anaf. );
  
  label &outvar = "Advisory Neighborhood Commission (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc12a.;
  %end;

%mend Block20_to_anc12;



