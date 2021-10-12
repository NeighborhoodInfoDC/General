/**************************************************************************
 Macro:    Block20_to_anc02
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC ANCs (2002).

 Modifications:
**************************************************************************/

%macro Block20_to_anc02( invar=geoblk2020, outvar=Anc2002, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk2an2f. );
  
  label &outvar = "Advisory Neighborhood Commission (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc02a.;
  %end;

%mend Block20_to_anc02;



