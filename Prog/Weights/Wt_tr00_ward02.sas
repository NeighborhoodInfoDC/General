/************************************************************************
  Program:  Wt_tr00_ward02.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  02/08/05
  Version:  SAS 8.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2000 tracts to
  2002 Wards.
 
  Modifications:
   06/15/05  Make data set uncompressed (compressed file larger).
             Corrected problem with 0 pop tract having missing weight.
             Removed obs. with weight of 0.
   04/05/06  Updated ward format to $ward02a.
   07/15/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Ward2002,
  out_ds = Wt_tr00_ward02,
  block_corr_ds = General.Block00_ward02, 
  block = GeoBlk2000,         
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc compare base=Save.Wt_tr00_ward02 compare=General.Wt_tr00_ward02 maxprint=(40,32000);
  id Geo2000 Ward2002;
  *var Pop Tract_Pop Popwt;
  *with Pop Pop_tr00 Popwt;
run;
