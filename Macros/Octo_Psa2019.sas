/**************************************************************************
 Macro:    Octo_Cluster2017
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  11/27/2019
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert OCTO cluster id to
 NeighborhoodInfo DC standard var Psa2019.

**************************************************************************/

%macro Octo_Psa2019( 
  invar=Name,      /** Input var **/
  outvar=Psa2019, /** Output var **/
  check=          /** Perform validity check? (Y/N) **/
  );

  Gis_id = &invar.;


  %let check = %upcase( &check );

   ** PSA code **;
  
  length &outvar $ 3;
  
  &outvar = upcase( left( &invar ) );
  
  label
    &outvar = "MPD Police Service Area (2019)";
    
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $psa19v. ) = '' then do;
      %warn_put( macro=Octo_Psa2019, msg="Invalid 2019 PSA ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Psa2019;



