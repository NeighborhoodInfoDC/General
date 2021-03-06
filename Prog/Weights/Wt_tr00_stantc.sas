/************************************************************************
  Program:  Wt_tr00_stanc.sas
  Library:  General
  Project:  Stanton Commons Custom Geography
  Author:   Yipeng Su
  Created:  4/25/2018
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  Stanton Commons area

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = stantoncommons,
  out_ds = Wt_tr00_stanc,
  block_corr_ds = General.Block00_stantoncommons, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

