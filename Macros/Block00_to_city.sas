/**************************************************************************
 Macro:    Block00_to_city
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Washington, D.C..

 Modifications:
  07/30/08  PAT  Changed var length to 1.
**************************************************************************/

%macro Block00_to_city( invar=geoblk2000, outvar=city, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0city. );
  
  label &outvar = "Washington, D.C.";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $city.;
  %end;

%mend Block00_to_city;



