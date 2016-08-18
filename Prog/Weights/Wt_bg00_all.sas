/**************************************************************************
 Program:  Wt_bg00_all.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/19/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/CONNECT
 
 Description:  Create weighting files for converting 
 2000 Census block groups to all other geographies.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Census )

** Start submitting commands to remote server **;

rsubmit;

/** Macro Create_wt_file - Start Definition **/

%macro Create_wt_file( geo );

  %let geo_name = %upcase( &geo );
  %put geo_name=&geo_name;

  %let geo_wt_file = %sysfunc( putc( &geo_name, $geobwtf. ) );;
  %put geo_wt_file=&geo_wt_file;
  
  %if &geo_wt_file = %then %do;
    %err_mput( macro=Create_wt_file, msg=Geography "&geo" not supported. )
    %goto exit_macro;
  %end;

  %let geo_var = %sysfunc( putc( &geo_name, $geoval. ) );
  %put geo_var=&geo_var;

  %let geo_label = %sysfunc( putc( &geo_name, $geodlbl. ) );
  %put geo_label=&geo_label;

  %let geo_fmt = %sysfunc( putc( &geo_name, $geoafmt. ) );
  %put geo_fmt=&geo_fmt;

  %let geo_macro = %sysfunc( putc( &geo_name, $geobk0m. ) );;
  %put geo_macro=&geo_macro;

  %let geo_sh_label = %sysfunc( putc( &geo_name, $geoslbl. ) );;
  %put geo_sh_label=&geo_sh_label;

  data &geo_wt_file._geo;

    set General.Geoblk2000;
    
    ** Census block group IDs **;
    
    %Block00_to_bg00()
    
    format GeoBg2000 ;
    
    ** Add target geo code **;
    
    %&geo_macro()
      
    keep GeoBlk2000 GeoBg2000 &geo_var;

  run;

  ** Find duplicates **;
  ** Each block should be assigned to only one geographic unit **;

  title2 '*** DUPLICATES WILL BE DELETED WITH PROC SORT NODUPKEY ***';

  %Dup_check(
    data=&geo_wt_file._geo,
    by=GeoBlk2000,
    id=GeoBg2000 &geo_var
  )

  title2;

  proc sort data=&geo_wt_file._geo nodupkey;
    by GeoBlk2000;
  run;

  /***%File_info( data=&geo_wt_file._geo, stats=, freqvars=&geo_var, printobs=40 )***/

  ** Add population totals for weighting **;

  proc sql;
    create table &geo_wt_file. (compress=no) as 
    select *, ( pop / bg_pop ) as popwt label="Population weight" from 
    ( select GeoBg2000, &geo_var format=&geo_fmt, sum( pop100 ) 
          as pop label="&geo_sh_label/block group population, 2000" from 
        (select * from 
           &geo_wt_file._geo 
               (keep=GeoBlk2000 GeoBg2000 &geo_var) as Blk 
             left join
           Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen
           on Blk.GeoBlk2000 = Cen.GeoBlk2000)
      group by GeoBg2000, &geo_var ) as BgGeo
        left join
    ( select GeoBg2000, sum( pop100 ) as bg_pop label="Block group population, 2000" from 
        (select * from 
           &geo_wt_file._geo 
               (keep=GeoBlk2000 GeoBg2000) as Blk2 
             left join
           Census.Cen2000_sf1_dc_blks (keep=GeoBlk2000 pop100) as Cen2
           on Blk2.GeoBlk2000 = Cen2.GeoBlk2000)
      group by GeoBg2000 ) as Bg
    on BgGeo.GeoBg2000 = Bg.GeoBg2000
    order by BgGeo.GeoBg2000, BgGeo.&geo_var
  ;

  /***%File_info( data=&geo_wt_file., printobs=40 )***/

  ** Remove/adjust missing weights **;

  data &geo_wt_file._b (compress=no);
       
    set &geo_wt_file.;
    
    ** If pop. = 0, set weight to 1 **;
    
    if popwt = . then popwt = 1;
    
    ** Remove obs. with weight 0 **;
    
    if popwt = 0 then delete;
    
  run;

  ** Normalize weights **;

  proc summary data=&geo_wt_file._b;
    by GeoBg2000;
    var popwt;
    output out=&geo_wt_file._sum (drop=_freq_ _type_ compress=no) sum= /autoname;
  run;

  data General.&geo_wt_file.
      (label="Weighting file, Census block group (2000) to &geo_label"
       sortedby=GeoBg2000 &geo_var
       compress=no);
       
    merge &geo_wt_file._b &geo_wt_file._sum;
    by GeoBg2000;
    
    if popwt_sum > 0 then popwt = popwt / popwt_sum;
    
    drop popwt_sum;

  run;

  ** Test that weights add up to total number of block groups **;

  proc summary data=General.&geo_wt_file. nway;
    class GeoBg2000;
    var popwt;
    output out=&geo_wt_file._test (drop=_freq_ _type_ compress=no) sum= ;
  run;

  proc print data=&geo_wt_file._test;
    where popwt ~= 1;
    id GeoBg2000;
    title2 "ATTENTION:  File = &geo_wt_file._test WHERE popwt ~= 1";
  run;

  proc datasets library=work;
    delete &geo_wt_file: /memtype=data;
  quit;

  %File_info( data=General.&geo_wt_file., printobs=40, freqvars=&geo_var )

  %exit_macro:

%mend Create_wt_file;

/** End Macro Definition **/

%Create_wt_file( geo2000 )
%Create_wt_file( cluster2000 )
%Create_wt_file( cluster_tr2000 )
%Create_wt_file( anc2002 )
%Create_wt_file( psa2004 )
%Create_wt_file( zip )
%Create_wt_file( casey_ta2003 )
%Create_wt_file( casey_nbr2003 )
%Create_wt_file( ward2002 )
%Create_wt_file( eor )
%Create_wt_file( city )

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;


