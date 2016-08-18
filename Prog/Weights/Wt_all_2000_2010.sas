/**************************************************************************
 Program:  Wt_all_2000_2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create weighting files to convert DC Census 2000 and 2010
 block groups and tracts.

 Modifications:
   07/21/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

** Wt_tr00_tr10: 2000 tracts to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Geo2010,
  out_ds = Wt_tr00_tr10,
  block_corr_ds = Census.Blk_xwalk_2000_2010_dc, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc sort data=Save.Wt_tr00_tr10 out=Wt_tr00_tr10;
  by Geo2000 Geo2010;

proc compare base=Wt_tr00_tr10 compare=General.Wt_tr00_tr10 maxprint=(40,32000);
  id Geo2000 Geo2010;
  var Popwt;
  with Popwt;
run;

** Wt_tr10_tr00: 2010 tracts to 2000 tracts **;

%Calc_weights_from_blocks( 
  geo1 = Geo2010, 
  geo2 = Geo2000,
  out_ds = Wt_tr10_tr00,
  block_corr_ds = Census.Blk_xwalk_2000_2010_dc, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc sort data=Save.Wt_tr10_tr00 out=Wt_tr10_tr00;
  by Geo2010 Geo2000;

proc compare base=Wt_tr10_tr00 compare=General.Wt_tr10_tr00 maxprint=(40,32000);
  id Geo2010 Geo2000;
  var Popwt;
  with Popwt;
run;

** Wt_bg00_tr00: 2000 block groups to 2000 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Geo2000,
  out_ds = Wt_bg00_tr00,
  block_corr_ds = Census.Blk_xwalk_2000_2010_dc, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Wt_bg00_tr10: 2000 block groups to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Geo2010,
  out_ds = Wt_bg00_tr10,
  block_corr_ds = Census.Blk_xwalk_2000_2010_dc, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Wt_bg10_tr00: 2010 block groups to 2000 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Geo2000,
  out_ds = Wt_bg10_tr00,
  block_corr_ds = Census.Blk_xwalk_2000_2010_dc, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

** Wt_bg10_tr10: 2010 block groups to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Geo2010,
  out_ds = Wt_bg10_tr10,
  block_corr_ds = Census.Blk_xwalk_2000_2010_dc, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

