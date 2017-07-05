/************************************************************************
  Program:  Wt_tr00_regcd.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  Regional Council Districts.

  Modifications: JD, 7/5/17:	Changed block_pop_ds to 2000 census data
							from DC, MD, and VA. 
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

options mprint symbolgen mlogic;

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = councildist,
  outlib = Work,
  out_ds = Wt_tr00_regcd,
  block_corr_ds = General.Block00_regcd, 
  block = GeoBlk2000,         
  block_pop_ds = Census.cen2000_nhgis_blks_dc_md_va_wv,  
  block_pop_var = FXS001, 
  block_pop_year = 2000
)

%Finalize_data_set( 
  data=Wt_tr00_regcd,
  out=Wt_tr00_regcd,
  outlib=General,
  label="Weighting file from 2000 tracts to Regional Council Districts",
  sortby=councildist,
  restrictions=None,
  revisions=New File.
  )
