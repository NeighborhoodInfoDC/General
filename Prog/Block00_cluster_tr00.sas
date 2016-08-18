/**************************************************************************
 Program:  Block00_cluster_tr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/15/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create 2000 block to 2000 tract-based cluster
 correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;


data General.Block00_cluster_tr00 
      (label="Census 2000 blocks (GeoBlk2000) to Tract-Based Neighborhood Cluster (Cluster_tr2000) correspondence file");

  set General.GeoBlk2000;
  
  length Cluster_tr2000 $ 2;
  
  Cluster_tr2000 = put( GeoBg2000, $bgrp_cl. );
  
  if Cluster_tr2000 = '' then Cluster_tr2000 = put( Geo2000, $trct_cl. );
  
  label Cluster_tr2000 = 'Neighborhood cluster (tract-based, 2000)';
  
run;

%File_info( data=General.Block00_cluster_tr00, stats=, freqvars=Cluster_tr2000 )

proc print data=General.Block00_cluster_tr00 noobs;
  where Cluster_tr2000 in ( '05', '06' );
  var Cluster_tr2000 Geo2000 GeoBg2000 GeoBlk2000;
  format Geo2000 GeoBg2000 GeoBlk2000 ;
run;
