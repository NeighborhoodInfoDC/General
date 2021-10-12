/**************************************************************************
 Macro:    Block20_to_zip
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC ZIP code.

 Modifications:
**************************************************************************/

%macro Block20_to_zip( invar=geoblk2020, outvar=Zip, format=Y );

  length &outvar $ 5;
  
  &outvar = put( &invar, $bk2zipf. );
  
  label &outvar = "ZIP code (5-digit)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $zipa.;
  %end;

%mend Block20_to_zip;



