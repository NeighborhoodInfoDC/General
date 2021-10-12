/**************************************************************************
 Macro:    Block20_to_bpk
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 Bridge Park area (2017).

 Modifications:
**************************************************************************/

%macro Block20_to_bpk( invar=geoblk2020, outvar=bridgepk, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2bpk. );
  
  label &outvar = "11th Street Bridge Park Target Area (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $bpka.;
  %end;

%mend Block20_to_bpk;



