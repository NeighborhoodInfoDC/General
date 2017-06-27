/**************************************************************************
 Macro:    Block00_to_regcnt
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Regional counties (2017).

 Modifications:
**************************************************************************/

%macro Block00_to_regcnt( invar=geoblk2000, outvar=county, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0regcnt. );
  
  label &outvar = "Regional counties (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $regcnta.;
  %end;

%mend Block00_to_regcnt;



