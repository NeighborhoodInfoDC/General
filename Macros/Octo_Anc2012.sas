/**************************************************************************
 Macro:    Octo_Anc2012
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/03/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert OCTO ANC ID to
 NeighborhoodInfo DC standard var Anc2012.

 Modifications:
**************************************************************************/

%macro Octo_Anc2012( 
  invar=ANC_ID,   /** Input var name **/
  outvar=Anc2012, /** Output var name **/
  check=n         /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  ** ANC code **;
  
  length &outvar $ 2;
  
  &outvar = upcase( left( &invar ) );

  label
    &outvar = "Advisory Neighborhood Commission (2012)";
  
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $anc12v. ) = '' then do;
      %warn_put( macro=Octo_Anc2012, msg="Invalid 2012 ANC ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Anc2012;



