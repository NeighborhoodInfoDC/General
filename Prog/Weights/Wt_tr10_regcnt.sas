/************************************************************************
  Program:  Wt_tr10_regcnt.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  Regional counties.

  Modifications: JD, 7/5/17:	Added data step to combine Census data
								from DC, MD, and VA.
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

data combined_census_pl_2010;  
	set Census.Census_pl_2010_dc Census.Census_pl_2010_md Census.Census_pl_2010_va;  
run;  

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = county,
  outlib = Work,
  out_ds = Wt_tr10_regcnt,
  block_corr_ds = General.Block10_regcnt, 
  block = GeoBlk2010,
  block_pop_ds = combined_census_pl_2010 (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

%Finalize_data_set( 
  data=Wt_tr10_regcnt,
  out=Wt_tr10_regcnt,
  outlib=General,
  label="Weighting file from 2010 tracts to Regional Counties",
  sortby=county,
  restrictions=None,
  revisions=New File.
  )
