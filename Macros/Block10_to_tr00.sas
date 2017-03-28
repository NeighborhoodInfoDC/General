/**************************************************************************
 Macro:    Block10_to_tr00
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Census tracts (2000).

 Modifications:
**************************************************************************/

%macro Block10_to_tr00( invar=geoblk2010, outvar=Geo2000, format=Y );

  length &outvar $ 11;
  
  &outvar = put( &invar, $bk1tr0f. );
  
  label &outvar = "Full census tract ID (2000): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo00a.;
  %end;

%mend Block10_to_tr00;



