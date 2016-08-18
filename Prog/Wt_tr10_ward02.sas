************************************************************************
* Program:  Wt_tr10_ward02.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  06/11/11
* Version:  SAS 9.1
* Environment:  Windows
* 
* Description:  Create weighting file for converting 2010 tracts to
* 2002 Wards.
*
* Modifications:
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

proc sql;
  create table Wt_tr10_ward02 (compress=no) as 
  select *, ( pop / tract_pop ) as popwt label="Population weight" from 
  ( select Geo2010, Ward2002 format=$ward02a., sum( p0010001 ) 
        as pop label="Ward/Tract population, 2010" from 
      (select * from 
         General.Block10_Ward02 
             (keep=GeoBlk2010 Geo2010 Ward2002) as Blk 
           left join
         Census.Census_pl_2010_dc (keep=GeoBlk2010 p0010001 sumlev where=(sumlev='750')) as Cen
         on Blk.GeoBlk2010 = Cen.GeoBlk2010)
    group by Geo2010, Ward2002 ) as TrGeo
      left join
  ( select Geo2010, sum( p0010001 ) as tract_pop label="Tract population, 2010"
    from Census.Census_pl_2010_dc (where=(sumlev='750'))
    group by Geo2010 ) as Tract
  on TrGeo.Geo2010 = Tract.Geo2010
  order by TrGeo.Geo2010, TrGeo.Ward2002
;

data General.Wt_tr10_ward02
    (label="Weighting file, 2010 tracts to 2002 Wards"
     sortedby=Geo2010 ward2002
     compress=no);
     
  set Wt_tr10_ward02;
  
  ** Set 0 pop. tract weights to 1 **;
  
  if popwt = . then popwt = 1;
  
  ** Remove obs. with weight 0 **;
  
  if popwt = 0 then delete;
  
  if put( Geo2010, $geo10v. ) = "" then do;
    %err_put( msg="Invalid census tract no. " Geo2010= )
  end;
  
run;
  
%File_info( data=General.Wt_tr10_ward02, printobs=1000, freqvars=ward2002 )

