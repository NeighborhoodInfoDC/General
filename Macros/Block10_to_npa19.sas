/**************************************************************************
 Macro:    Block10_to_npa19
 Library:  general
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  12/20/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to NPA (2019).

 Modifications:
**************************************************************************/

%macro Block10_to_npa19( invar=geoblk2010, outvar=npa2019, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1npa19f. );
  
  label &outvar = "NPA (2019)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $npa19a.;
  %end;

%mend Block10_to_npa19;



