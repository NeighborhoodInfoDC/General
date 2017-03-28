/**************************************************************************
 Macro:    Block00_to_tr00
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/04/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Census tracts (2000).

 Modifications:
**************************************************************************/

%macro Block00_to_tr00( invar=geoblk2000, outvar=Geo2000, format=Y );

  length &outvar $ 11;
  
  &outvar = left( &invar );
  
  label &outvar = "Full census tract ID (2000): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo00a.;
  %end;

%mend Block00_to_tr00;



