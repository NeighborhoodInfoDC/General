/************************************************************************
  Program:  Wt_tr00_psa19.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Eleanor Noble
  Created:  12/10/2019
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  2019 PSAs.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, /*this is 2000 tracts*/
  geo2 = PSA2019, /*converting to this geo*/
  out_ds = Wt_tr00_psa19, /*data set being created*/
  block_corr_ds = General.Block00_PSA19, /*created this correspondence in the previous set*/
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  /*pop by block*/
  block_pop_var = pop100, 
  block_pop_year = 2000
)

/*change geo2, outds and block_corr_ds*/
