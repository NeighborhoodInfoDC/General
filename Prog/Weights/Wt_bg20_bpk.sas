/************************************************************************
  Program:  Wt_bg20_bpk.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/16/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 block groups to
  Bridge Park Area.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = bridgepk,
  out_ds = Wt_bg20_bpk,
  block_corr_ds = General.Block20_bpk, 
  block = GeoBlk2020,         
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

