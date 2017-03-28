/**************************************************************************
 Macro:    Block00_to_cluster_tr00
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/30/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 DC Neighborhood Clusters (tract-based, 2000).

 Modifications:
**************************************************************************/

%macro Block00_to_cluster_tr00( invar=geoblk2000, outvar=Cluster_tr2000, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0cl0f. );
  
  if put( substr( &invar, 1, 11), $trct_cl. ) ~= "" then
    &outvar = put( substr( &invar, 1, 11), $trct_cl. );
  else 
    &outvar = put( substr( &invar, 1, 12), $bgrp_cl. );
  
  label &outvar = "Neighborhood cluster (tract-based, 2000)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus00a.;
  %end;

%mend Block00_to_cluster_tr00;



