/************************************************************************
  Program:  Wt_bg00_voterpre2012.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  12/17/12
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 block groups to
  2012 Voting Precincts 

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = VoterPre2012,
  out_ds = Wt_bg00_vp12,
  block_corr_ds = General.Block00_voterpre2012, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

