/************************************************************************
  Program:  Wt_bg00_regcd.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 block groups to
  Regional Council Districts.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = councildist,
  outlib = Work,
  out_ds = Wt_bg00_regcd,
  block_corr_ds = General.Block00_regcd, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

%Finalize_data_set( 
  data=Wt_bg00_regcd,
  out=Wt_bg00_regcd,
  outlib=General,
  label="Weighting file from 2000 block groups to Regional Council Districts",
  sortby=councildist,
  restrictions=None,
  revisions=New File.
  )
