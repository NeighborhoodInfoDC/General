/**************************************************************************
 Program:  Wt_taz00_cltr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/28/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create weighting file for converting 2000
 Transportation Analysis Zones (TAZ) to 
 2000 neighborhood clusters (tract-based).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

data Block00_Ward02_Taz00;

  set General.block00_ward02_taz00;
  
  ** Ward code **;
  
  %Octo_ward2002()
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** Cluster code **;
  
  %Block00_to_cluster_tr00()
  
  ** TAZ code **;
  
  length Taz2000 $ 3;
  
  if Taz > 0 then Taz2000 = put( Taz, z3. );
  
  label 
    CJRTRACTBL = "OCTO tract/block ID"
    Gis_id = "OCTO Ward ID"
    NAME = "Ward code"
    X = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    Y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
    Taz2000 = "Transportation Analysis Zone (2000)"
  ;
  
  ** Remove conflicting duplicate obs. **;
  
  if GEOBLK2000 = "110010072001000" and Taz2000 = "180" and Cluster_tr2000 = "27" then delete;

  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  format x y 10.2;
  
  keep Geo2000 GeoBlk2000 Ward2002 Cluster_tr2000 CJRTRACTBL Gis_id NAME x y Taz2000;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

title2 '*** DUPLICATES WILL BE DELETED WITH PROC SORT NODUPKEY ***';

%Dup_check(
  data=Block00_Ward02_Taz00,
  by=GeoBlk2000,
  id=Taz2000 Cluster_tr2000
)

title2;

proc sort data=Block00_Ward02_Taz00 nodupkey;
  by GeoBlk2000;

%File_info( data=Block00_Ward02_Taz00, stats=, freqvars=Cluster_tr2000 )

run;

proc sql;
  create table Wt_taz00_cltr00 (compress=no) as 
  select *, ( pop / taz_pop ) as popwt label="Population weight" from 
  ( select Taz2000, Cluster_tr2000 format=$ward02a., sum( pop100 ) 
        as pop label="Ward/Taz population, 2000" from 
      (select * from 
         Block00_Ward02_Taz00 
             (keep=GeoBlk2000 Taz2000 Cluster_tr2000) as Blk 
           left join
         Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen
         on Blk.GeoBlk2000 = Cen.GeoBlk2000)
    group by Taz2000, Cluster_tr2000 ) as TazGeo
      left join
  ( select Taz2000, sum( pop100 ) as taz_pop label="Taz population, 2000" from 
      (select * from 
         Block00_Ward02_Taz00 
             (keep=GeoBlk2000 Taz2000) as Blk2 
           left join
         Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen2
         on Blk2.GeoBlk2000 = Cen2.GeoBlk2000)
    group by Taz2000 ) as Taz
  on TazGeo.Taz2000 = Taz.Taz2000
  order by TazGeo.Taz2000, TazGeo.Cluster_tr2000
  ;


** Remove/adjust missing weights **;

data Wt_taz00_cltr00_b (compress=no);
     
  set Wt_taz00_cltr00;
  
  ** If pop. = 0, set weight to 1 **;
  
  if popwt = . then popwt = 1;
  
  ** Remove obs. with weight 0 **;
  
  if popwt = 0 then delete;
  
run;

** Normalize weights **;

proc summary data=Wt_taz00_cltr00_b;
  by Taz2000;
  var popwt;
  output out=Sum_Wt_taz00_cltr00 (drop=_freq_ _type_ compress=no) sum= /autoname;
run;

data General.Wt_taz00_cltr00
    (label="Weighting file, 2000 TAZ to 2000 neighborhood clusters (tract-based)"
     sortedby=Taz2000 Cluster_tr2000
     compress=no);

  merge Wt_taz00_cltr00_b Sum_Wt_taz00_cltr00;
  by Taz2000;
  
  if popwt_sum > 0 then popwt = popwt / popwt_sum;
  
  drop popwt_sum;
  
run;

** Test that weights add up to total number of TAZs **;

proc summary data=General.Wt_taz00_cltr00;
  by Taz2000;
  var popwt;
  output out=Test_Wt_taz00_cltr00 (drop=_freq_ _type_ compress=no) sum= /autoname;
run;

proc print data=Test_Wt_taz00_cltr00;
  where popwt_sum ~= 1;
  id Taz2000;
  title2 'ATTENTION:  File = Test_Wt_taz00_cltr00 WHERE popwt ~= 1';
run;

%File_info( data=General.Wt_taz00_cltr00, printobs=40, freqvars=Cluster_tr2000 )

