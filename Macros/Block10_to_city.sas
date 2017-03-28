/**************************************************************************
 Macro:    Block10_to_city
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Washington, D.C..

 Modifications:
  07/30/08  PAT  Changed var length to 1.
**************************************************************************/

%macro Block10_to_city( invar=geoblk2010, outvar=city, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1city. );
  
  label &outvar = "Washington, D.C.";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $city.;
  %end;

%mend Block10_to_city;



