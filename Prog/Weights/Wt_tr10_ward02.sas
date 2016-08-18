/************************************************************************
  Program:  Wt_tr10_ward02.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  06/11/11
  Version:  SAS 9.1
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 tracts to
  2002 Wards.

  Modifications:
   07/07/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = Geo2010,
  geo2 = Ward2002,
  out_ds = Wt_tr10_ward02,
  block_corr_ds = General.Block10_Ward02, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

libname save "D:\DCData\Libraries\General\Data\Save";

proc compare base=Save.Wt_tr10_ward02 compare=General.Wt_tr10_ward02 maxprint=(40,32000);
  id Geo2010 Ward2002;
  *var Pop Tract_Pop Popwt ;
  *with Pop Pop_tr10 Popwt ;
run;

