/**************************************************************************
 Macro:    Octo_NPA2019
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  12/18/2019
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert OCTO npa id to
 NeighborhoodInfo DC standard var NPA2019.

**************************************************************************/

%macro Octo_npa2019( 
  invar=OBJECTID,      /** Input var **/
  outvar=npa2019, /** Output var **/
  check=          /** Perform validity check? (Y/N) **/
  );

  Gis_id = &invar.;


  %let check = %upcase( &check );

   ** NPA code **;
  
  length &outvar $ 1;
  
  &outvar = upcase( left( &invar ) );
  
  label
    &outvar = "Neighborhood Planning Area (2019)";
    
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $npa19v. ) = '' then do;
      %warn_put( macro=Octo_NPA2019, msg="Invalid 2019 NPA ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_npa2019;



