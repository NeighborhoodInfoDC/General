/************************************************************************
  Program:  Wt_bg10_city.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  03/21/13
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  city.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010,
  geo2 = city,
  out_ds = Wt_bg10_city,
  block_corr_ds = General.GeoBlk2010, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

