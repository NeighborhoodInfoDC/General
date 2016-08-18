/**************************************************************************
 Program:  Wt_tr00_cltr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/02/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create tract to neighborhood cluster (tract/block
 based def.) weighting file.
 
 Modifications:
   04-05-06 PAT Updated to new file standards.
   07/15/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Cluster_tr2000,
  out_ds = Wt_tr00_cltr00,
  block_corr_ds = General.Block00_cluster_tr00, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc sort data=Save.Wt_tr00_cltr00 out=Wt_tr00_cltr00;
  by Geo2000 Cluster_tr2000;

proc compare base=Wt_tr00_cltr00 compare=General.Wt_tr00_cltr00 maxprint=(40,32000);
  id Geo2000 Cluster_tr2000;
  var Popwt;
  with Popwt;
run;

