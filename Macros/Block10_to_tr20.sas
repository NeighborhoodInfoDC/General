/**************************************************************************
 Macro:    Block10_to_tr20
 Library:  Macros
 Project:  Urban Greater-DC
 Author:   L. Hendey
 Created:  05/03/2024
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Census tracts (2020).

 Modifications:
**************************************************************************/

%macro Block10_to_tr20( invar=geoblk2010, outvar=Geo2020, format=Y );

  length &outvar $ 11;
  
  &outvar = put( &invar, $bk1tr2f. );
  
  label &outvar = "Full census tract ID (2020): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo20a.;
  %end;

%mend Block10_to_tr20;



