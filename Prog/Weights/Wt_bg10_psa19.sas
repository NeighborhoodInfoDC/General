/************************************************************************
  Program:  Wt_bg10_psa19.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Eleanor Noble
  Created:  12/10/2019
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  2019 PSAs.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010,
  geo2 = PSA2019,
  out_ds = Wt_bg10_psa19,
  block_corr_ds = General.Block10_PSA19, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

