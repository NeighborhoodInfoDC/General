/************************************************************************
  Program:  Wt_tr20_stanc.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/24/21
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 tracts to
  Stanton Commons area

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2020,
  geo2 = stantoncommons,
  out_ds = Wt_tr20_stanc,
  block_corr_ds = General.Block20_stantoncommons,
  block = GeoBlk2020,
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

