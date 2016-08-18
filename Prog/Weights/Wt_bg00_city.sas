/**************************************************************************
 Program:  Wt_bg00_city.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  3/22/2013
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create weighting file to convert 2000 block groups to 
 city total.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000,
  geo2 = city,
  out_ds = Wt_bg00_city,
  block_corr_ds = General.GeoBlk2000, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

