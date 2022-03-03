/************************************************************************
  Program:  Wt_tr10_ward22.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  03/03/22
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  2022 Wards.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = Ward2022,
  out_ds = Wt_tr10_ward22,
  block_corr_ds = General.Block10_ward22, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

