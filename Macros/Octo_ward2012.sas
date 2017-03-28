/**************************************************************************
 Macro:    Octo_Ward2012
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO ward id to
 NeighborhoodInfo DC standard var Ward2012.

 Modifications:
  07/14/12 PAT Corrected variable label. 
**************************************************************************/

%macro Octo_Ward2012( 
  invar=ward,      /** Input var **/
  outvar=Ward2012, /** Output var **/
  check=n          /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  length &outvar $ 1;
  
  &outvar = put( &invar, 1. );

  label
    &outvar = "Ward (2012)";

  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $ward12v. ) = '' then do;
      %warn_put( macro=Octo_Ward2012, msg="Invalid 2012 Ward ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Ward2012;



