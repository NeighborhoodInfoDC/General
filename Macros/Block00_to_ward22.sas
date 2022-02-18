/**************************************************************************
 Macro:    Block00_to_ward12
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  02/18/22
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 DC wards (2022).

 Modifications:
**************************************************************************/

%macro Block00_to_ward22( invar=geoblk2000, outvar=Ward2022, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0wdbf. );
  
  label &outvar = "Ward (2022)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $ward22a.;
  %end;

%mend Block00_to_ward22;



