/************************************************************************
  Program:  Wt_bg00_psa12.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  07/07/12
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 block groups to
  2012 PSAs.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Psa2012,
  out_ds = Wt_bg00_psa12,
  block_corr_ds = General.Block00_psa12, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

