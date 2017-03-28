/**************************************************************************
 Macro:    Block10_to_bpk
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  02/16/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Bridge Park area (2017).

 Modifications:
**************************************************************************/

%macro Block10_to_bpk( invar=geoblk2010, outvar=bridgepk, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1bpk. );
  
  label &outvar = "11th Street Bridge Park Target Area (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $bpka.;
  %end;

%mend Block10_to_bpk;



