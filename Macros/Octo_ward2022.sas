/**************************************************************************
 Macro:    Octo_Ward2022
 Library:  Octo
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  02/16/2022
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO ward id to
 Urban-Greater DC standard var Ward2022.

 Modifications:
**************************************************************************/

%macro Octo_Ward2022( 
  invar=ward,      /** Input var **/
  outvar=Ward2022, /** Output var **/
  check=n          /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  length &outvar $ 1;
  
  &outvar = put( &invar, 1. );

  label
    &outvar = "Ward (2022)";

  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $ward22v. ) = '' then do;
      %warn_put( macro=Octo_Ward2022, msg="Invalid 2022 Ward ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Ward2022;



