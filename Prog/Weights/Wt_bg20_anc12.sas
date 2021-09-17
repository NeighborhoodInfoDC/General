/************************************************************************
  Program:  Wt_bg20_anc12.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/16/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 block groups to
  2012 ANCs.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = Anc2012,
  out_ds = Wt_bg20_anc12,
  block_corr_ds = Block20_ANC12, 
  block = GeoBlk2020,         
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

