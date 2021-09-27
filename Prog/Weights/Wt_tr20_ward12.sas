/************************************************************************
  Program:  Wt_tr20_ward12.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/24/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 tracts to
  2012 Wards.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2020,
  geo2 = Ward2012,
  out_ds = Wt_tr20_ward12,
  block_corr_ds = General.Block20_Ward12, 
  block = GeoBlk2020,
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

