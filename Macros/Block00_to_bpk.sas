/**************************************************************************
 Macro:    Block00_to_bpk
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  02/16/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Bridge Park Area (2017).

 Modifications:
**************************************************************************/

%macro Block00_to_bpk( invar=geoblk2000, outvar=bridgepk, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0bpk. );
  
  label &outvar = "11th Street Bridge Park Target Area (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $bpka.;
  %end;

%mend Block00_to_bpk;



