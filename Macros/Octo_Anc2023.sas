/**************************************************************************
 Macro:    Octo_Anc2023
 Library:  General
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  05/01/2025
 Version:  SAS 9.4
 Environment:  Windows 11
 
 Description: Convert OCTO ANC ID to
 NeighborhoodInfo DC standard var Anc2023.

 Modifications:
**************************************************************************/

%macro Octo_Anc2023( 
  invar=ANC_ID,   /** Input var name **/
  outvar=Anc2023, /** Output var name **/
  check=n         /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  ** ANC code **;
  
  length &outvar $ 4;
  
  &outvar = upcase( left( &invar ) );

  label
    &outvar = "Advisory Neighborhood Commission (2023)";
  
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $anc23v. ) = '' then do;
      %warn_put( macro=Octo_Anc2023, msg="Invalid 2023 ANC ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Anc2023;



