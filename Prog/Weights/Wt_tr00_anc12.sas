/************************************************************************
  Program:  Wt_tr00_anc12.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  07/04/12
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  2012 ANCs.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Anc2012,
  out_ds = Wt_tr00_anc12,
  block_corr_ds = General.Block00_anc12, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

libname save "D:\DCData\Libraries\General\Data\Save";

proc compare base=Save.Wt_tr00_anc12 compare=General.Wt_tr00_anc12 maxprint=(40,32000);
  id Geo2000 anc2012;
  **var Pop Anc_Pop Tract_Pop Popwt Popwt_prop;
  /*with Pop Pop_anc12 Pop_tr00 Popwt Popwt_prop;*/
run;

