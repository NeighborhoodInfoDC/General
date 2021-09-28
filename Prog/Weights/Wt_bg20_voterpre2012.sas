/************************************************************************
  Program:  Wt_bg20_voterpre2012.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/20/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 block groups to
  2012 Voting Precincts 

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = VoterPre2012,
  out_ds = Wt_bg20_vp12,
  block_corr_ds = General.Block20_VoterPre2012, 
  block = GeoBlk2020,         
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2020
)
