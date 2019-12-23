/**************************************************************************
 Program:  Wt_bg00_npa19
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  12/20/2019
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create weighting file for converting 2000 block groups to
 2019 NPAs.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = NPA2019,
  out_ds = Wt_bg00_NPA19,
  block_corr_ds = General.Block00_NPA19, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)



