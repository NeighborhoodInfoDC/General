/**************************************************************************
 Program:  Wt_taz10_all.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  08/14/18
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Create weighting files to convert 2010 TAZ to standard
 DC geographies. 

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

** Read TAZ 2010 block crosswalk file **;

filename fimport "L:\Libraries\General\Maps\Census 2010\Block10_taz10.csv" lrecl=1000;

proc import out=Block10_taz10
    datafile=fimport
    dbms=csv replace;
  datarow=2;
  getnames=yes;
  guessingrows=max;
run;

filename fimport clear;

data Block10_taz10;

  set Block10_taz10;
  
  length GeoBlk2010 $ 15;
  
  GeoBlk2010 = put( FIPSSTCO, z5. ) || put( tract, z6. ) || put( block, z4. );
  
  length Taz2010 $ 8;
  
  Taz2010 = put( FIPSSTCO, z5. ) || put( taz, z3. );
  
  %Block10_to_anc02()
  %Block10_to_anc12()
  %Block10_to_bpk()
  %Block10_to_city()
  %Block10_to_cluster_tr00()
  %Block10_to_cluster00()
  %Block10_to_cluster17()
  %Block10_to_eor()
  %Block10_to_psa04()
  %Block10_to_psa12()
  %Block10_to_stantoncommons()
  %Block10_to_tr00()
  %Block10_to_tr10()
  %Block10_to_vp12()
  %Block10_to_ward02()
  %Block10_to_ward12()
  %Block10_to_zip()

  format _all_ ;
  informat _all_ ;
  
  label
    GeoBlk2010 = "Full census block ID (2010): sscccttttttbbbb"
    Taz2010 = "Traffic analysis zone (2010): ssccczzz";
  
run;

%File_info( data=Block10_taz10 )

%Dup_check(
  data=Block10_taz10,
  by=GeoBlk2010 Taz2010,
  id=distance,
  out=_dup_check,
  listdups=Y,
  count=dup_check_count,
  quiet=N,
  debug=N
)

/** Macro GeoWt - Start Definition **/

%macro GeoWt( geo );
 
  %local geosuf;
  
  %if %sysfunc( putc( %upcase(&geo), $geoval. ) ) ~= %then %do;
    %let geosuf = %sysfunc( putc( %upcase(&geo), $geosuf. ) );
  %end;
  %else %do;
    %err_mput( macro=GeoWt, msg=Invalid or missing value of geography (GEO=&geo). )
    %goto exit_macro;
  %end;

  %Calc_weights_from_blocks( 
    geo1 = Taz2010, 
    geo1check = n,
    geo1suf=_taz10,
    geo1name=TAZ,
    geo1dlbl=Traffic analysis zone (2010),
    geo2 = &geo,
    out_ds = Wt_taz10&geosuf,
    block_corr_ds = Block10_taz10,
    block = GeoBlk2010, 
    block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),  
    block_pop_var = p0010001, 
    block_pop_year = 2010
  )

  run;
  
  %exit_macro:

%mend GeoWt;

/** End Macro Definition **/


%GeoWt( anc2002 )
%GeoWt( anc2012 )
%GeoWt( bridgepk )
%GeoWt( city )
%GeoWt( cluster_tr2000 )
%GeoWt( cluster2000 )
%GeoWt( cluster2017 )
%GeoWt( eor )
%GeoWt( psa2004 )
%GeoWt( psa2012 )
%GeoWt( stantoncommons )
%GeoWt( Geo2000 )
%GeoWt( Geo2010 )
%GeoWt( voterpre2012 )
%GeoWt( ward2002 )
%GeoWt( ward2012 )
%GeoWt( zip )

