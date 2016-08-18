/**************************************************************************
 Program:  Wt_bg00_zip.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  3/22/2013
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create weighting file for converting 2000 block groups to
 ZIP codes.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Zip,
  out_ds = Wt_bg00_zip,
  block_corr_ds = General.Block00_zip, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc compare base=Save.Wt_bg00_zip compare=General.Wt_bg00_zip maxprint=(40,32000);
  id GeoBg2000 Zip;
  var Pop Bg_Pop Popwt;
  with Pop Pop_bg00 Popwt;
run;

