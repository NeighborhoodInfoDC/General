/**************************************************************************
 Macro:    Block20_to_ward12
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC wards (2012).

 Modifications:
**************************************************************************/

%macro Block20_to_ward12( invar=geoblk2020, outvar=Ward2012, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2wdaf. );
  
  label &outvar = "Ward (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $ward12a.;
  %end;

%mend Block20_to_ward12;



