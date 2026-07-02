/**************************************************************************
 Program:  Wt_all_2010_2020.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create weighting files to convert DC Census 2010 and 2020
 block groups and tracts.

 Modifications:
   07/21/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
   12/27/17 RP Updated for weighting the entire region. 
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )


** Combine 2010 population files for each state **;
data census_pl_2010_dmvw;
	set census.census_pl_2010_dc census.census_pl_2010_md
		census.census_pl_2010_va census.census_pl_2010_wv;
run;

** Combine 2020 population files for each state **;
data census_pl_2020_dmvw;
	set census.census_pl_2020_dc census.census_pl_2020_md
		census.census_pl_2020_va census.census_pl_2020_wv;
run;


** Combine crosswalk files for each state **;
data blk_xwalk_2010_2020_dmvw;
	set Census.Blk_xwalk_2010_2020_dc Census.Blk_xwalk_2010_2020_md
		Census.Blk_xwalk_2010_2020_va Census.Blk_xwalk_2010_2020_wv;
run;


** Wt_tr10_tr20: 2010 tracts to 2020 tracts **;

%Calc_weights_from_blocks( 
  geo1 = Geo2010, 
  geo2 = Geo2020,
  geo1check=n,
  geo2check=n,
  out_ds = Wt_tr10_tr20,
  block_corr_ds = Work.blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2010,
  block_pop_ds = Work.Census_pl_2010_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

** Wt_tr20_tr10: 2020 tracts to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = Geo2020, 
  geo2 = Geo2010,
  geo1check=n,
  geo2check=n,
  out_ds = Wt_tr20_tr10,
  block_corr_ds = Work.blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2020,
  block_pop_ds = Work.Census_pl_2020_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

** Wt_bg00_tr10: 2010 block groups to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Geo2010,
  geo1check=n,
  geo2check=n,
  out_ds = Wt_bg00_tr10,
  block_corr_ds = Work.blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2010,
  block_pop_ds = Work.Census_pl_2010_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

** Wt_bg00_tr20: 2010 block groups to 2020 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = Geo2020,
  geo1check=n,
  geo2check=n,
  out_ds = Wt_bg00_tr20,
  block_corr_ds = Work.blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2010,
  block_pop_ds = Work.Census_pl_2010_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

** Wt_bg10_tr10: 2020 block groups to 2010 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = Geo2010,
  geo1check=n,
  geo2check=n,
  out_ds = Wt_bg10_tr10,
  block_corr_ds = Work.blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2020,
  block_pop_ds = Work.Census_pl_2020_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

** Wt_bg10_tr20: 2020 block groups to 2020 tracts **;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020, 
  geo2 = Geo2020,
  geo1check=n,
  geo2check=n,
  out_ds = Wt_bg10_tr20,
  block_corr_ds = Work.blk_xwalk_2010_2020_dmvw, 
  block = GeoBlk2020,
  block_pop_ds = Work.Census_pl_2020_dmvw (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2020
)


