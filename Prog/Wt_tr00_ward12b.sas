************************************************************************
* Program:  Wt_tr00_ward12b.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  06/11/11
* Version:  SAS 9.1
* Environment:  Windows
* 
* Description:  Create weighting file for converting 2000 tracts to
* 2012 Wards (draft 6/8/11).
*
* Modifications:
   06/13/11 PAT  Corrected definitions of wards 1, 3, 4.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

proc sql;
  create table Wt_tr00_ward12b (compress=no) as 
  select *, ( pop / tract_pop ) as popwt label="Population weight" from 
  ( select Geo2000, ward2012b format=$ward12a., sum( pop100 ) 
        as pop label="Ward/Tract population, 2000" from 
      (select * from 
         General.Block00_ward12b 
             (keep=GeoBlk2000 Geo2000 ward2012b) as Blk 
           left join
         Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen
         on Blk.GeoBlk2000 = Cen.GeoBlk2000)
    group by Geo2000, ward2012b ) as TrGeo
      left join
  ( select Geo2000, sum( pop100 ) as tract_pop label="Tract population, 2000"
    from Census.Cen2000_sf1_dc_blks
    group by Geo2000 ) as Tract
  on TrGeo.Geo2000 = Tract.Geo2000
  order by TrGeo.Geo2000, TrGeo.ward2012b
;

data General.Wt_tr00_ward12b
    (label="Weighting file, 2000 tracts to 2012 Wards (draft 6/8/11)"
     sortedby=geo2000 ward2012b
     compress=no);
     
  set Wt_tr00_ward12b;
  
  ** Tract 57.02 has 0 pop., so set weight to 1 **;
  
  if popwt = . then popwt = 1;
  
  ** Remove obs. with weight 0 **;
  
  if popwt = 0 then delete;
  
  if put( geo2000, $geo00v. ) = "" then do;
    %err_put( msg="Invalid census tract no. " geo2000= )
  end;
  
run;
  
%File_info( data=General.Wt_tr00_ward12b, printobs=1000, freqvars=ward2012b )

