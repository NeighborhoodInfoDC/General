/**************************************************************************
 Program:  Wt_bg20_cnty.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  02/16/24
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  150
 
 Description:  Create weighting file for converting 2020 block groups to
 counties (ucounty).

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

data combined_census_pl_2020;  
	set Census.Census_pl_2020_dc Census.Census_pl_2020_md Census.Census_pl_2020_va Census.Census_pl_2020_wv;  
	where sumlev='750';
	keep GeoBlk2020 p0010001;
run;  

** Block to county correspondence **;

data Block20_cnty;

  set General.Geoblk2020;
  
  length ucounty $ 5;
  
  ucounty = left( geo2020 );
  
  label ucounty = "County (ssccc)";
  
run;

%Calc_weights_from_blocks( 
  geo1 = GeoBg2020,
  geo2 = ucounty,
  outlib = Work,
  out_ds = Wt_bg20_cnty,
  block_corr_ds = Block20_cnty, 
  block = GeoBlk2020,
  block_pop_ds = combined_census_pl_2020,
  block_pop_var = p0010001, 
  block_pop_year = 2020
)

%Finalize_data_set( 
  data=Wt_bg20_cnty,
  out=Wt_bg20_cnty,
  outlib=General,
  label="Weighting file from 2020 tracts to counties",
  sortby=ucounty,
  restrictions=None,
  revisions=New File.,
  freqvars=ucounty
  )

run;
