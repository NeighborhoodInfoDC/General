/**************************************************************************
 Macro:    Block00_to_npa19
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  12/518/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to NPA (2019).

 Modifications:
**************************************************************************/

%macro Block00_to_npa19( invar=geoblk2000, outvar=npa2019, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $$bk0ps9f. );
  
  label &outvar = "NPA (2019)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $npa19a.;
  %end;

%mend Block00_to_npa19;



