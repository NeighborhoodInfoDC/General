/**************************************************************************
 Program:  Wt_bg00_cltr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/13
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create block group to neighborhood cluster (tract/block
 based def.) weighting file.
 
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Cluster_tr2000,
  out_ds = Wt_bg00_cltr00,
  block_corr_ds = General.Block00_cluster_tr00, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc compare base=Save.Wt_bg00_cltr00 compare=General.Wt_bg00_cltr00 maxprint=(40,32000);
  id GeoBg2000 Cluster_tr2000;
  var Pop Bg_Pop Popwt;
  with Pop Pop_bg00 Popwt;
run;

