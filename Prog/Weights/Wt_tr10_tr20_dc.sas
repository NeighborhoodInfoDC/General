/**************************************************************************
 Program:  Wt_tr10_tr20_dc.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   L Hendey
 Created:  07-01-2026
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create 2010 to 2020 tract weighting file for DC. Based on Wt_tr00_tr10_dc.sas

 Modifications: 
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

** Add population counts to block crosswalk file **;

proc sql noprint;
  create table xwalk_pop as
  select * from 
    Census.Blk_xwalk_2010_2020_dc (keep=geoblk: arealand: areawater: block_part_flag_:) 
      as xwalk
      left join 
    Census.Census_sf1_2010_dc_blks (keep=geoblk2010 p1i1) as cen2010
  on xwalk.geoblk2010 = cen2010.geoblk2010
;

run;

proc print;

