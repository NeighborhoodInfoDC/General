/************************************************************************
  Program:  Wt_bg10_anc12.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  03/21/13
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  2012 ANCs.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Anc2012,
  out_ds = Wt_bg10_anc12,
  block_corr_ds = General.Block10_anc12, 
  block = GeoBlk2010,         
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

