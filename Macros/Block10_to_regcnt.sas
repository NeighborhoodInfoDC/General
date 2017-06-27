/**************************************************************************
 Macro:    Block10_to_regcnt
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Regional counties (2017).

 Modifications:
**************************************************************************/

%macro Block10_to_regcnt( invar=geoblk2010, outvar=county, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1regcnt. );
  
  label &outvar = "Regional counties (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $regcnta.;
  %end;

%mend Block10_to_regcnt;



