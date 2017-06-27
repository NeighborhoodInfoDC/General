/**************************************************************************
 Macro:    Regcnt
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/20/17
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert geoid to
 NeighborhoodInfo DC standard var county.

 Modifications:
**************************************************************************/

%macro Regcnt( 
  invar=geoid,   /** Input var name **/
  outvar=county, /** Output var name **/
  check=n         /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  ** geoid code **;
  
  length &outvar $ 2;
  
  &outvar = upcase( left( &invar ) );

  label
    &outvar = "Regional counties (2017)";
  
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $regcntv. ) = '' then do;
      %warn_put( macro=Regcnt, msg="Invalid geoid ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Regcnt;



