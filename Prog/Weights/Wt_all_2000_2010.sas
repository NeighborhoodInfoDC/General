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
   12/27/17 RP Updated for weighting the entire region. 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )


** Combine 2010 population files for each state **;
data census_pl_2010_dmvw;
	set census.census_pl_2010_dc census.census_pl_2010_md
		census.census_pl_2010_va census.census_pl_2010_wv;
run;


** Combine crosswalk files for each state **;
data blk_xwalk_2000_2010_dmvw;
	set Census.Blk_xwalk_2000_2010_dc Census.Blk_xwalk_2000_2010_md
		Census.Blk_xwalk_2000_2010_va Census.Blk_xwalk_2000_2010_wv;
run;


** Wt_tr00_tr10: 2000 tracts to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Geo2010,
  out_ds = Wt_tr00_tr10,
  block_corr_ds = Work.blk_xwalk_2000_2010_dmvw, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_nhgis_blks_dc_md_va_wv,  
  block_pop_var = FXS001, 
  block_pop_year = 2000
)


** Wt_tr10_tr00: 2010 tracts to 2000 tracts **;

%Calc_weights_from_blocks( 
  geo1 = Geo2010, 
  geo2 = Geo2000,
  out_ds = Wt_tr10_tr00,
  block_corr_ds = Work.blk_xwalk_2000_2010_dmvw, 
  block = GeoBlk2010,
  block_pop_ds = Work.Census_pl_2010_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)


** Wt_bg00_tr00: 2000 block groups to 2000 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Geo2000,
  out_ds = Wt_bg00_tr00,
  block_corr_ds = Work.blk_xwalk_2000_2010_dmvw, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_nhgis_blks_dc_md_va_wv,  
  block_pop_var = FXS001, 
  block_pop_year = 2000
)

** Wt_bg00_tr10: 2000 block groups to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2000, 
  geo2 = Geo2010,
  out_ds = Wt_bg00_tr10,
  block_corr_ds = Work.blk_xwalk_2000_2010_dmvw, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_nhgis_blks_dc_md_va_wv,  
  block_pop_var = FXS001, 
  block_pop_year = 2000
)

** Wt_bg10_tr00: 2010 block groups to 2000 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Geo2000,
  out_ds = Wt_bg10_tr00,
  block_corr_ds = Work.blk_xwalk_2000_2010_dmvw, 
  block = GeoBlk2010,
  block_pop_ds = Work.Census_pl_2010_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

** Wt_bg10_tr10: 2010 block groups to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Geo2010,
  out_ds = Wt_bg10_tr10,
  block_corr_ds = Work.blk_xwalk_2000_2010_dmvw, 
  block = GeoBlk2010,
  block_pop_ds = Work.Census_pl_2010_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

