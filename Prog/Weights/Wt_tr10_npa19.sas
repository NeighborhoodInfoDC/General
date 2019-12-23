/************************************************************************
  Program:  Wt_tr10_npa19.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   Eleanor Noble
  Created:  12/20/2019
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  2019 NPAs.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = NPA2019,
  out_ds = Wt_tr10_npa19,
  block_corr_ds = General.Block10_NPA19,
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

