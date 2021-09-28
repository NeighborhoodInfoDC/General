/************************************************************************
  Program:  Wt_bg20_city.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/20/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create weighting file for converting 2020 block groups to
  city.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

data GeoBlk2020_city;
	set General.GeoBlk2020;
	if state = '11';
	city = '1';
run;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020,
  geo2 = city,
  out_ds = Wt_bg20_city,
  block_corr_ds = GeoBlk2020_city, 
  block = GeoBlk2020,
  block_pop_ds = Census.Census_pl_2020_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

