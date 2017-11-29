/**************************************************************************
 Program:  Wt_tr00_tr10_dc.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/05/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create 2000 to 2010 tract weighting file for DC.

 Modifications:
**************************************************************************/

/*%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";*/
%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

** Add population counts to block crosswalk file **;

proc sql noprint;
  create table xwalk_pop as
  select * from 
    Census.Blk_xwalk_2000_2010_dc (keep=geoblk: arealand: areawater: block_part_flag_:) 
      as xwalk
      left join 
    Census.Cen2000_sf1_dc_blks (keep=geoblk2000 p1i1) as cen2000
  on xwalk.geoblk2000 = cen2000.geoblk2000
;

run;

proc print;

