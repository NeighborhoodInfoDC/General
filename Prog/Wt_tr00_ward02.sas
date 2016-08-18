************************************************************************
* Program:  Wt_tr00_ward02.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  02/08/05
* Version:  SAS 8.2
* Environment:  Windows
* 
* Description:  Create weighting file for converting 2000 tracts to
* 2002 Wards.
*
* Modifications:
   06/15/05  Make data set uncompressed (compressed file larger).
             Corrected problem with 0 pop tract having missing weight.
             Removed obs. with weight of 0.
   04/05/06  Updated ward format to $ward02a.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( Census )

proc sql;
  create table Wt_tr00_ward02 (compress=no) as 
  select *, ( pop / tract_pop ) as popwt label="Population weight" from 
  ( select Geo2000, Ward2002 format=$ward02a., sum( pop100 ) 
        as pop label="Ward/Tract population, 2000" from 
      (select * from 
         General.Block00_Ward02 
             (keep=GeoBlk2000 Geo2000 Ward2002) as Blk 
           left join
         Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen
         on Blk.GeoBlk2000 = Cen.GeoBlk2000)
    group by Geo2000, Ward2002 ) as TrGeo
      left join
  ( select Geo2000, sum( pop100 ) as tract_pop label="Tract population, 2000"
    from Census.Cen2000_sf1_dc_blks
    group by Geo2000 ) as Tract
  on TrGeo.Geo2000 = Tract.Geo2000
  order by TrGeo.Geo2000, TrGeo.Ward2002
;

data General.Wt_tr00_ward02
    (label="Weighting file, 2000 tracts to 2002 Wards"
     sortedby=geo2000 ward2002
     compress=no);
     
  set Wt_tr00_ward02;
  
  ** Tract 57.02 has 0 pop., so set weight to 1 **;
  
  if popwt = . then popwt = 1;
  
  ** Remove obs. with weight 0 **;
  
  if popwt = 0 then delete;
  
  if put( geo2000, $geo00v. ) = "" then do;
    %err_put( msg="Invalid census tract no. " geo2000= )
  end;
  
run;
  
%File_info( data=General.Wt_tr00_ward02, printobs=1000, freqvars=ward2002 )

