/**************************************************************************
 Macro:    Regcd
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/20/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert regcd to
 NeighborhoodInfo DC standard var councildist.

 Modifications:
**************************************************************************/

%macro Regcd( 
  invar=regcd,   /** Input var name **/
  outvar=councildist, /** Output var name **/
  check=n         /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  ** regcd code **;
  
  length &outvar $ 4;
  
  &outvar = upcase( left( &invar ) );

  label
    &outvar = "Regional Council District (2017)";
  
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $regcdv. ) = '' then do;
      %warn_put( macro=Regcd, msg="Invalid regcd ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Regcd;



