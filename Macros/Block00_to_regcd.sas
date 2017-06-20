/**************************************************************************
 Macro:    Block00_to_regcd
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Regional Council District Areas (2017).

 Modifications:
**************************************************************************/

%macro Block00_to_regcd( invar=geoblk2000, outvar=councildist, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0regcd. );
  
  label &outvar = "Regional council districts (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $regcda.;
  %end;

%mend Block00_to_regcd;



