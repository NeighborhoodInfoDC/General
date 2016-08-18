************************************************************************
* Program:  Wt_tr10_ward12b.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  06/11/11
* Version:  SAS 9.1
* Environment:  Windows
* 
* Description:  Create weighting file for converting 2010 tracts to
* 2012 Wards (draft 6/8/11).
*
* Modifications:
   06/13/11 PAT  Corrected definitions of wards 1, 3, 4.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

proc sql;
  create table Wt_tr10_ward12b (compress=no) as 
  select *, ( pop / tract_pop ) as popwt label="Population weight" from 
  ( select Geo2010, Ward2012b format=$ward12a., sum( p0010001 ) 
        as pop label="Ward/Tract population, 2010" from 
      (select * from 
         General.Block10_ward12b
             (keep=GeoBlk2010 Geo2010 Ward2012b) as Blk 
           left join
         Census.Census_pl_2010_dc (keep=GeoBlk2010 p0010001 sumlev where=(sumlev='750')) as Cen
         on Blk.GeoBlk2010 = Cen.GeoBlk2010)
    group by Geo2010, Ward2012b ) as TrGeo
      left join
  ( select Geo2010, sum( p0010001 ) as tract_pop label="Tract population, 2010"
    from Census.Census_pl_2010_dc (where=(sumlev='750'))
    group by Geo2010 ) as Tract
  on TrGeo.Geo2010 = Tract.Geo2010
  order by TrGeo.Geo2010, TrGeo.Ward2012b
;

data General.Wt_tr10_ward12b
    (label="Weighting file, 2010 tracts to 2012 Wards (draft 6/8/11)"
     sortedby=Geo2010 Ward2012b
     compress=no);
     
  set Wt_tr10_ward12b;
  
  ** Set 0 pop. tract weights to 1 **;
  
  if popwt = . then popwt = 1;
  
  ** Remove obs. with weight 0 **;
  
  if popwt = 0 then delete;
  
  if put( Geo2010, $geo10v. ) = "" then do;
    %err_put( msg="Invalid census tract no. " Geo2010= )
  end;
  
run;
  
%File_info( data=General.Wt_tr10_ward12b, printobs=1000, freqvars=Ward2012b )

