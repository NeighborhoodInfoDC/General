/**************************************************************************
 Macro:    Octo_StantonCommons
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  3/15/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert OCTO field to
 NeighborhoodInfo DC standard var StantonCommons. 

**************************************************************************/

%macro Octo_StantonCommons( 
  invar=_stanc,      /** Input var **/
  outvar=stantoncommons, /** Output var **/
  check=          /** Perform validity check? (Y/N) **/
  );

  &invar._num = &invar.;

  Gis_id = &invar.;


  %let check = %upcase( &check );

  length &outvar $ 1;
  
  &outvar = put( &invar._num, z1. );

  label
    &outvar = "Stanton Commons (2018)";

  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $stancv. ) = ' ' then do;
      %warn_put( macro=Octo_stantoncommons, msg="Invalid StantonCommons ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_stantoncommons;



