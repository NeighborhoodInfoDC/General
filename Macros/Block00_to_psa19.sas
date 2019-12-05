/**************************************************************************
 Macro:    Block00_to_psa19
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  12/5/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to PSA (2019).

 Modifications:
**************************************************************************/

%macro Block00_to_psa19( invar=geoblk2000, outvar=psa2019, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $$bk0ps9f. );
  
  label &outvar = "PSA (2019)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa2019a.;
  %end;

%mend Block00_to_psa19;



