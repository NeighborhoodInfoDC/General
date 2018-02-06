/**************************************************************************
 Macro:    Octo_Cluster2017
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  12/07/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert OCTO cluster id to
 NeighborhoodInfo DC standard var cluster2017.

**************************************************************************/

%macro Octo_cluster2017( 
  invar=clusterID,      /** Input var **/
  outvar=cluster2017, /** Output var **/
  check=          /** Perform validity check? (Y/N) **/
  );

  length &invar. $ 2;

  &invar.=substr(name,9,2);
  &invar._num = &invar. +0;

  Gis_id = &invar.;


  %let check = %upcase( &check );

  length &outvar $ 2;
  
  &outvar = put( &invar._num, z2. );

  label
    &outvar = "Cluster (2017)";

  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $clus17v. ) = ' ' then do;
      %warn_put( macro=Octo_cluster2017, msg="Invalid 2017 cluster ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_Cluster2017;



