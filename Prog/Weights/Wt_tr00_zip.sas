/**************************************************************************
 Program:  Wt_tr00_zip.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create weighting file for converting 2000 tracts to
 ZIP codes.

 Modifications:
   07/21/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Zip,
  out_ds = Wt_tr00_zip,
  block_corr_ds = General.Block00_zip, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc sort data=Save.Wt_tr00_zip out=Wt_tr00_zip;
  by Geo2000 Zip;

proc compare base=Wt_tr00_zip compare=General.Wt_tr00_zip maxprint=(40,32000);
  id Geo2000 Zip;
  var Popwt Tract_pop;
  with Popwt Pop_tr00;
run;

