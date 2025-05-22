/************************************************************************
  Program:  Wt_bg20_anc23.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Rob Pitingolo
  Created:  05/08/2023
  Version:  SAS 9.4
  Environment:  Windows 11
  
  Description:  Create weighting file for converting 2020 block groups to
  2023 ANCs.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = Anc2023,
  out_ds = Wt_bg20_anc23,
  block_corr_ds = General.Block20_anc23, 
  block = GeoBlk2020,         
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

