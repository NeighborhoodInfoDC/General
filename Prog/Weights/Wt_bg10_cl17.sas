/************************************************************************
  Program:  Wt_bg10_cl17.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Yipeng Su
  Created:  12/08/17
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  2017 neighborhood clusters.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010,
  geo2 = cluster2017,
  out_ds = Wt_bg10_cl17,
  block_corr_ds = General.Block10_cluster2017, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

