/**************************************************************************
 Macro:    Create_summary_from_tracts
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/29/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Create geographic summary data set
 from a tract summary data set for the specified geography.

 Modifications:
  09/26/06  Added LIB= parameter.
  11/21/06  Modify SORTEDBY= option for output data set.
  12/08/06  Changed $GEOLBL to $GEODLBL.
  12/22/10 PAT Added MPRINT= parameter.
  02/24/11 PAT Added declaration for local macro vars.
  07/14/12 PAT Added TRACT_YR= parameter for specifying source tract year.
**************************************************************************/

%macro Create_summary_from_tracts( 
  geo=, 
  lib=,
  outlib=,
  data_pre=,
  data_label=,
  count_vars=, 
  prop_vars=,
  calc_vars=,
  calc_vars_labels=,
  tract_yr=,
  register=, 
  creator_process=,
  restrictions=,
  revisions=,
  mprint=n
);

  %local wtfile geosuf geodlbl geofmt tractid;

  %let geo = %upcase( &geo );
  %let register = %upcase( &register );
  
  %if &tract_yr = 2000 %then %do;
    %let tractid = Geo2000;
    %let wtfile = %sysfunc( putc( &geo, $geotw0f. ) );
  %end;
  %else %if &tract_yr = 2010 %then %do;
    %let tractid = Geo2010;
    %let wtfile = %sysfunc( putc( &geo, $geotw1f. ) );
  %end;
  %else %if &tract_yr = 2020 %then %do;
    %let tractid = Geo2020;
    %let wtfile = %sysfunc( putc( &geo, $geotw2f. ) );
  %end;
  %else %do;
    %err_mput( macro=Create_summary_from_tracts, 
               msg=Must specify source tract year as 2000 or 2010 or 2020: TRACT_YR=&tract_yr.. )
    %note_mput( macro=Create_summary_from_tracts, msg=Macro exiting. )
    %goto exit_macro;
  %end;
  
  %if %sysfunc( putc( &geo, $geoval. ) ) ~= %then %do;
    %let geosuf = %sysfunc( putc( &geo, $geosuf. ) );
    %let geodlbl = %sysfunc( putc( &geo, $geodlbl. ) );
    %let geofmt = %sysfunc( putc( &geo, $geoafmt. ) );
  %end;
  %else %do;
    %err_mput( macro=Create_summary_from_tracts, 
               msg=Invalid or missing value of GEO= parameter: GEO=&geo.. )
    %note_mput( macro=Create_summary_from_tracts, msg=Macro exiting. )
    %goto exit_macro;
  %end;

  %note_mput( macro=Create_summary_from_tracts, 
              msg=Creating &geo level data from &tract_yr census tracts. )

  %Transform_geo_data(
      dat_ds_name=%if &tract_yr = 2000 %then &lib..&data_pre._tr00;
		%else %if &tract_yr = 2010 %then &lib..&data_pre._tr10;
		%else %if &tract_yr = 2020 %then &lib..&data_pre._tr20;,
      dat_org_geo=&tractid,
      dat_count_vars=&count_vars,
      dat_prop_vars=&prop_vars,
      wgt_ds_name=General.&wtfile,
      wgt_org_geo=&tractid,
      wgt_new_geo=&geo,
      wgt_new_geo_fmt=&geofmt,
      wgt_id_vars=,
      wgt_count_var=popwt,
      wgt_prop_var=popwt_prop,
      out_ds_name=&data_pre.&geosuf,
      out_ds_label=%quote(&data_label, &geodlbl),
      calc_vars=&calc_vars,
      calc_vars_labels=&calc_vars_labels,
      keep_nonmatch=N,
      show_warnings=10,
      print_diag=Y,
      full_diag=N,
      mprint=&mprint
    )
  
	%if &register = Y %then %do;
	    %Finalize_data_set(
	    data=&data_pre.&geosuf,
	    out=&data_pre.&geosuf,
	    outlib=&outlib.,
	    label="&data_label.",
	    sortby=&geo,
	    /** Metadata parameters **/
	    revisions=%str(&revisions),
	    /** File info parameters **/
	    printobs=0,
	    freqvars=&geo
	    )
  %end;

  %exit_macro:

%mend Create_summary_from_tracts;



