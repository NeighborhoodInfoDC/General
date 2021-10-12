/**************************************************************************
 Macro:    Block20_to_city
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 Washington, D.C..

 Modifications:
**************************************************************************/

%macro Block20_to_city( invar=geoblk2020, outvar=city, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2city. );
  
  label &outvar = "Washington, D.C.";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $city.;
  %end;

%mend Block20_to_city;



