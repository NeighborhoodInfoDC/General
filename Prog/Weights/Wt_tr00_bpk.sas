/************************************************************************
  Program:  Wt_tr00_bpk.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  02/16/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  Bridge Park Area.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

options mprint symbolgen mlogic;

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = bridgepk,
  out_ds = Wt_tr00_bpk,
  block_corr_ds = General.Block00_bpk, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

