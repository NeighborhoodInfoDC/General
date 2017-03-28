/**************************************************************************
 Macro:    Bridgepk
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  02/16/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Bridgepk ID to
 NeighborhoodInfo DC standard var bridgepk

 Modifications:
**************************************************************************/

%macro Bridgepk( 
  invar=bridgepkID,      /** Input var **/
  outvar=bridgepk, /** Output var **/
  check=n          /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  length &outvar $ 1;
  
  &outvar = put( &invar, 1. );

  label
    &outvar = "11th Street Bridge Park Target Area (2017)";

  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $bpkv. ) = '' then do;
      %warn_put( macro=Bridgepk, msg="Invalid Bridge Park ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Bridgepk;



