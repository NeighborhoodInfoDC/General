/**************************************************************************
 Macro:    Block10_to_regcd
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Regional Council District Areas (2017).

 Modifications:
**************************************************************************/

%macro Block10_to_regcd( invar=geoblk2010, outvar=councildist, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1regcd. );
  
  label &outvar = "Regional council districts (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $regcda.;
  %end;

%mend Block10_to_regcd;



