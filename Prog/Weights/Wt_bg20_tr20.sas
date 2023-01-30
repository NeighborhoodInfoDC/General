/************************************************************************
  Program:  Wt_bg20_tr20.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Rob Pitingolo
  Created:  01/30/2023
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 block groups to
  2020 tracts.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

** Combine 2020 population files for each state **;
data census_pl_2020_dmvw;
	set census.Census_pl_2020_dc census.Census_pl_2020_md
		census.Census_pl_2020_va census.Census_pl_2020_wv;
run;


** Combine crosswalk files for each state **;
data blk_xwalk_2010_2020_dmvw;
	set Census.Blk_xwalk_2010_2020_dc Census.Blk_xwalk_2010_2020_md
		Census.Blk_xwalk_2010_2020_va Census.Blk_xwalk_2010_2020_wv;
run;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = Geo2020,
  out_ds = Wt_bg20_tr20,
  block_corr_ds = blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2020,         
  block_pop_ds = census_pl_2020_dmvw (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2020
)
