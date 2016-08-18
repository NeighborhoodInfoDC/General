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
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( Census )

proc sql;
  create table Wt_tr00_zip (compress=no) as 
  select *, ( pop / tract_pop ) as popwt label="Population weight" from 
  ( select Geo2000, Zip format=$zipa., sum( pop100 ) 
        as pop label="ZIP/Tract population, 2000" from 
      (select * from 
         General.Block00_zip 
             (keep=GeoBlk2000 Geo2000 Zip) as Blk 
           left join
         Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen
         on Blk.GeoBlk2000 = Cen.GeoBlk2000)
    group by Geo2000, Zip ) as TrGeo
      left join
  ( select Geo2000, sum( pop100 ) as tract_pop label="Tract population, 2000"
    from Census.Cen2000_sf1_dc_blks
    group by Geo2000 ) as Tract
  on TrGeo.Geo2000 = Tract.Geo2000
  order by TrGeo.Geo2000, TrGeo.Zip
;

data General.Wt_tr00_zip
    (label="Weighting file, 2000 tracts to ZIP codes (5-digit)"
     sortedby=geo2000 Zip
     compress=no);
     
  set Wt_tr00_zip;
  
  ** Tract 57.02 has 0 pop., so set weight to 1 **;
  
  if popwt = . then popwt = 1;
  
  ** Remove obs. with weight 0 **;
  
  if popwt = 0 then delete;
  
  if put( geo2000, $geo00v. ) = "" then do;
    %err_put( msg="Invalid census tract no. " geo2000= )
  end;
  
run;

%File_info( data=General.Wt_tr00_zip, printobs=1000 )


run;
