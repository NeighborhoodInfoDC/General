/************************************************************************
  Program:  Wt_tr00_regcnt.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  Regional Counties.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

options mprint symbolgen mlogic;

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = county,
  outlib = Work,
  out_ds = Wt_tr00_regcnt,
  block_corr_ds = General.Block00_regcnt, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

%Finalize_data_set( 
  data=Wt_tr00_regcnt,
  out=Wt_tr00_regcnt,
  outlib=General,
  label="Weighting file from 2000 tracts to Regional Counties",
  sortby=county,
  restrictions=None,
  revisions=New File.
  )
