/************************************************************************
  Program:  Wt_bg00_ward02.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  3/22/2013
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 block groups to
  2002 Wards.
 
  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Ward2002,
  out_ds = Wt_bg00_ward02,
  block_corr_ds = General.Block00_ward02, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc compare base=Save.Wt_bg00_ward02 compare=General.Wt_bg00_ward02 maxprint=(40,32000);
  id GeoBg2000 Ward2002;
  var Pop Bg_Pop Popwt;
  with Pop Pop_bg00 Popwt;
run;
