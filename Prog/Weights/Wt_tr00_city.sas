/**************************************************************************
 Program:  Wt_tr00_city.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create weighting file to convert 2000 tracts to city total.

 Modifications:
   07/21/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

/*
** Merge with tract list to create full weighting file **;

data General.Wt_tr00_city 
      (label="Weighting file, 2000 tracts to Washington, D.C. city total"
       compress=no);

  set General.Geo2000 (keep=geo2000);

  city = "1";
    
  popwt = 1;

  format city $city.;

  label
    geo2000 = "Census 2000 Tract ID: ssccctttttt"
    city = "Washington, D.C."
    popwt = "Population weight";

run;

%File_info( data=General.Wt_tr00_city, printobs=200, freqvars=city )

*/

%Calc_weights_from_blocks( 
  geo1 = Geo2000,
  geo2 = city,
  out_ds = Wt_tr00_city,
  block_corr_ds = General.GeoBlk2000, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

