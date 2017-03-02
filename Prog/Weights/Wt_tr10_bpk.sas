/************************************************************************
  Program:  Wt_tr10_bpk.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  02/16/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  Bridge Park Area.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = bridgepk,
  out_ds = Wt_tr10_bpk,
  block_corr_ds = General.Block10_bpk, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

%Finalize_data_set( 
  data=Wt_tr10_bpk,
  out=Wt_tr10_bpk,
  outlib=General,
  label="Weighting file from 2010 tracts to Bridge Park Area",
  sortby=bridgepk,
  restrictions=None,
  revisions=New File.
  )
