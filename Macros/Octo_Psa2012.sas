/**************************************************************************
 Macro:    Octo_Psa2012
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/03/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert OCTO PSA ID to
 NeighborhoodInfo DC standard var Psa2012.

 Modifications:
**************************************************************************/

%macro Octo_Psa2012( 
  invar=Name,     /** Input var name **/
  outvar=Psa2012, /** Output var name **/
  check=n         /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  ** PSA code **;
  
  length &outvar $ 3;
  
  &outvar = upcase( left( &invar ) );
  
  label
    &outvar = "MPD Police Service Area (2012)";
    
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $psa12v. ) = '' then do;
      %warn_put( macro=Octo_Psa2012, msg="Invalid 2012 PSA ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Psa2012;



