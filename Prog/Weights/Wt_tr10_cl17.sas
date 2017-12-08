/************************************************************************
  Program:  Wt_tr10_cl17.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Yipeng Su
  Created:  12/08/2017
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  2017 neighborhood clusters.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = Cluster2017,
  out_ds = Wt_tr10_cl17,
  block_corr_ds = General.Block10_cluster2017,
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

