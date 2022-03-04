/************************************************************************
  Program:  Wt_tr00_ward22.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Elizabeth Burton
  Created:  03/03/22
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  2022 Wards.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Ward2022,
  out_ds = Wt_tr00_ward22,
  block_corr_ds = General.Block00_ward22,
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

