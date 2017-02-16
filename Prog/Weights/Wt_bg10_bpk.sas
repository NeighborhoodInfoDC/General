/************************************************************************
  Program:  Wt_bg10_bpk.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  02/16/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  Bridge Park Area.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = bridgepk,
  out_ds = Wt_bg10_bpk,
  block_corr_ds = General.Block10_bpk, 
  block = GeoBlk2010,         
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),  
  block_pop_var = pop100, 
  block_pop_year = 2010
)

