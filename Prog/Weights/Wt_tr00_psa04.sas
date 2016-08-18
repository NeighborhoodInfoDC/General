************************************************************************
* Program:  Wt_tr00_psa04.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  09/08/04
* Version:  SAS 8.12
* Environment:  Windows
* 
* Description:  Create weighting file for converting 2000 tracts to
* 2004 PSAs.
*
* Modifications:
*  08/20/06  PAT Corrected problem with missing pop. weight.
   07/21/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Psa2004,
  out_ds = Wt_tr00_psa04,
  block_corr_ds = General.Block00_psa04, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc sort data=Save.Wt_tr00_psa04 out=Wt_tr00_psa04;
  by Geo2000 Psa2004;

proc compare base=Wt_tr00_psa04 compare=General.Wt_tr00_psa04 maxprint=(40,32000);
  id Geo2000 Psa2004;
  var Popwt Tract_pop;
  with Popwt Pop_tr00;
run;

