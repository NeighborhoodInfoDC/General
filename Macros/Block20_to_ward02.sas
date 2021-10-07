/**************************************************************************
 Macro:    Block20_to_ward02
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC wards (2002).

 Modifications:
**************************************************************************/

%macro Block20_to_ward02( invar=geoblk2020, outvar=Ward2002, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2wd2f. );
  
  label &outvar = "Ward (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $ward02a.;
  %end;

%mend Block20_to_ward02;



