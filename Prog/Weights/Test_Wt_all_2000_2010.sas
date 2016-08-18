/**************************************************************************
 Program:  Test_Wt_all_2000_2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Test new Census 2000/2010 weighting files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )
%DCData_lib( NCDB )

title2 '-- Tract 2000 to Tract 2010 --';

%Transform_geo_data(
    dat_ds_name=Ncdb.Ncdb_lf_2000_dc,
    dat_org_geo=geo2000,
    dat_count_vars=trctpop0,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr00_tr10,
    wgt_org_geo=geo2000,
    wgt_new_geo=geo2010,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Test_geo2000_geo2010,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

proc print data=Test_geo2000_geo2010 (obs=40);

proc means data=Ncdb.Ncdb_lf_2000_dc n sum;
  var trctpop0;
  
proc means data=Test_geo2000_geo2010 n sum;
  var trctpop0;
  
run;

title2 '-- Tract 2010 to Tract 2000 --';

data Census_pl_2010_dc;

  set Census.Census_pl_2010_dc 
    (where=(sumlev='140')
     keep=sumlev geo2010 p0010001);
  
run;

%Transform_geo_data(
    dat_ds_name=Census_pl_2010_dc,
    dat_org_geo=geo2010,
    dat_count_vars=p0010001,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr10_tr00,
    wgt_org_geo=geo2010,
    wgt_new_geo=geo2000,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Test_geo2010_geo2000,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

proc print data=Test_geo2010_geo2000 (obs=40);

proc means data=Census_pl_2010_dc n sum;
  var p0010001;
  
proc means data=Test_geo2010_geo2000 n sum;
  var p0010001;
  
run;


title2 '-- Block group 2000 to Block group 2010 --';

data Cen2000_sf1_dc_ph;

  set Census.Cen2000_sf1_dc_ph  
    (where=(sumlev='150')
     keep=sumlev geo2000 bg p1i1);
  
  length geobg2000 $ 12;
  
  geobg2000 = geo2000 || bg;
  
run;

%Transform_geo_data(
    dat_ds_name=Cen2000_sf1_dc_ph,
    dat_org_geo=geobg2000,
    dat_count_vars=p1i1,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_bg00_bg10,
    wgt_org_geo=geobg2000,
    wgt_new_geo=geobg2010,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Test_geobg2000_geobg2010,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

proc print data=Test_geobg2000_geobg2010 (obs=40);

proc means data=Cen2000_sf1_dc_ph n sum;
  var p1i1;
  
proc means data=Test_geobg2000_geobg2010 n sum;
  var p1i1;
  
run;

title2 '-- Block group 2010 to Block group 2000 --';

data Census_pl_2010_dc;

  set Census.Census_pl_2010_dc 
    (where=(sumlev='150')
     keep=sumlev geobg2010 p0010001);
  
run;

%Transform_geo_data(
    dat_ds_name=Census_pl_2010_dc,
    dat_org_geo=geobg2010,
    dat_count_vars=p0010001,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_bg10_bg00,
    wgt_org_geo=geobg2010,
    wgt_new_geo=geobg2000,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Test_geobg2010_geobg2000,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

proc print data=Test_geobg2010_geobg2000 (obs=40);

proc means data=Census_pl_2010_dc n sum;
  var p0010001;
  
proc means data=Test_geobg2010_geobg2000 n sum;
  var p0010001;
  
run;

