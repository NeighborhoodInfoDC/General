/************************************************************************
  Program:  Wt_tr00_anc23.sas
  Library:  General
  Project:  Urban Greater DC
  Author:   Rob Pitingolo
  Created:  05/08/25
  Version:  SAS 9.4
  Environment:  Windows 11
  
  Description:  Create weighting file for converting 2000 tracts to
  2023 ANCs.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Anc2023,
  out_ds = Wt_tr00_anc23,
  block_corr_ds = General.Block00_anc23,
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

