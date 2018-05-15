/************************************************************************
  Program:  Wt_tr10_stanc.sas
  Library:  General
  Project:  Stanton Commons custom geography
  Author:   Yipeng Su
  Created:  4/25/2018
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  Stanton Commons area

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = stantoncommons,
  out_ds = Wt_tr10_stanc,
  block_corr_ds = General.Block10_stantoncommons,
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

