/************************************************************************
  Program:  Wt_bg10_regcd.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  Regional Council Districts.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010, 
  geo2 = councildist,
  outlib = Work,
  out_ds = Wt_bg10_regcd,
  block_corr_ds = General.Block10_regcd, 
  block = GeoBlk2010,         
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),  
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

%Finalize_data_set( 
  data=Wt_bg10_regcd,
  out=Wt_bg10_regcd,
  outlib=General,
  label="Weighting file from 2010 block groups to Regional Council Districts",
  sortby=councildist,
  restrictions=None,
  revisions=New File.
  )
