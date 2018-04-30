/**************************************************************************
 Program:  Calc_weights_from_blocks.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/07/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro to calculate weights using block-level
 population counts and block-to-geo correspondence file.

 Modifications:
  07/15/12 PAT Added Pieces_ vars = num. pieces for geography splits.
               Changed calculation for cases where weight is missing 
               (0 population) to 1 / number of geography splits.
  07/21/12 PAT No longer remove obs. where popwt = 0 and popwt_prop = 0 
               (causes problems when using pieces as weights).
  02/02/17 JD  Added library option.
  12/27/17 RP  Replaced %File_info() with %Finalize_data_set().
**************************************************************************/

/** Macro Calc_weights_from_blocks - Start Definition **/

%macro Calc_weights_from_blocks( 
  geo1=,           /** Source geography **/
  geo2=,           /** Target geography **/
  outlib=,		   /** Library, default General **/
  out_ds=,         /** Output data set name **/
  block_corr_ds=,  /** Block-to-geo correspondence data set **/
  block=,          /** Block ID variable **/
  block_pop_ds=,   /** Block population data set **/
  block_pop_var=,  /** Block population variable **/
  block_pop_year=, /** Block population year **/
  revisions=	   /** Revisions to the final file **/
  );

  %local geo1suf geo1name geo1dlbl geo1vfmt 
         geo2suf geo2name geo2dlvl geo2vfmt geo2fmt;

  ** Set output library **;
  %if %length( &outlib ) = 0 %then %let outlib = General;

  %** Check geo parameters **;
  
  %let geo1 = %upcase( &geo1 );
  %let geo2 = %upcase( &geo2 );

  %if %sysfunc( putc( &geo1, $geoval. ) ) ~= %then %do;
    %let geo1suf = %sysfunc( putc( &geo1, $geosuf. ) );
    %let geo1name = %sysfunc( putc( &geo1, $geoslbl. ) );
    %let geo1dlbl = %sysfunc( putc( &geo1, $geodlbl. ) );
    %let geo1vfmt = %sysfunc( putc( &geo1, $geovfmt. ) );
  %end;
  %else %do;
    %err_mput( macro=Calc_weights_from_blocks, msg=Invalid or missing value of geography (GEO1=&geo1). )
    %goto exit_macro;
  %end;

  %if %sysfunc( putc( &geo2, $geoval. ) ) ~= %then %do;
    %let geo2suf = %sysfunc( putc( &geo2, $geosuf. ) );
    %let geo2name = %sysfunc( putc( &geo2, $geoslbl. ) );
    %let geo2dlbl = %sysfunc( putc( &geo2, $geodlbl. ) );
    %let geo2fmt = %sysfunc( putc( &geo2, $geoafmt. ) );
    %let geo2vfmt = %sysfunc( putc( &geo2, $geovfmt. ) );
  %end;
  %else %do;
    %err_mput( macro=Calc_weights_from_blocks, msg=Invalid or missing value of geography (geo2=&geo2). )
    %goto exit_macro;
  %end;
  
  %note_mput( macro=Calc_weights_from_blocks, msg=Creating weight file &out_ds.. )

  proc sql;
    /** Step 1: Merge block population counts with correspondence file **/
    create table _Block_pop as
    select &geo1., &geo2. format=&geo2fmt, 
        sum( &block_pop_var. ) as Pop label="&geo2name.-&geo1name. piece population, &block_pop_year." from 
      ( select coalesce( Blk.&block., Cen.&block. ), Blk.&geo1., Blk.&geo2., Cen.&block_pop_var. from 
          &block_corr_ds. as Blk 
            left join
          &block_pop_ds. as Cen
          on Blk.&block. = Cen.&block. )
    group by &geo1., &geo2.;

    /** Step 2: Create weights from summary population counts **/
    create table &out_ds (compress=no) as 
    select *,
           ( Pop / Pop&geo1suf. ) as Popwt label="Population weight for counts (Pop / Pop&geo1suf.)",
           ( Pop / Pop&geo2suf. ) as Popwt_prop label="Population weight for proportions (Pop / Pop&geo2suf.)" from 
      ( select * from 
          _Block_pop
            left join
        ( select &geo1., 
                 count(*) as Pieces&geo1suf. label="&geo1name. pieces split by &geo2name.", 
                 sum( pop ) as Pop&geo1suf. label="&geo1name. population, &block_pop_year."
          from _Block_pop
          group by &geo1. ) as Source
        on _Block_pop.&geo1. = Source.&geo1. ) as Source_pop
      left join
      ( select &geo2., 
               count(*) as Pieces&geo2suf. label="&geo2name. pieces split by &geo1name.", 
               sum( pop ) as Pop&geo2suf. label="&geo2name. population, &block_pop_year."
        from _Block_pop 
        group by &geo2. ) as Target_pop
      on Source_pop.&geo2. = Target_pop.&geo2.
    order by Source_pop.&geo1., Target_pop.&geo2.
  ;
  quit;

  data &out_ds.
      (label="Weighting file, &geo1dlbl to &geo2dlbl"
       sortedby=&geo1 &geo2
       compress=no);
       
    set &out_ds;
    
    ** Set missing weights to 1 / # of pieces **;
    
    if popwt = . then popwt = 1 / Pieces&geo1suf.;
    
    if popwt_prop = . then popwt_prop = 1 / Pieces&geo2suf.;
    
    ** NO LONGER DOING THIS (7/21/12) - Remove obs. with weight 0 **;
    
    ***if popwt = 0 and popwt_prop = 0 then delete;
    
    %if &geo1vfmt ~= %then %do;
      ** Check source geo for invalid values **;

      if put( &geo1., &geo1vfmt ) = "" then do;
        %err_put( msg="Invalid &geo1name: " &geo1= )
      end;
    %end;
    
    %if &geo2vfmt ~= %then %do;
      ** Check target geo for invalid values **;

      if put( &geo2., &geo2vfmt ) = "" then do;
        %err_put( msg="Invalid &geo2name: " &geo2= )
      end;
    %end;
  
  run;
  
  %Finalize_data_set( 
  data=&out_ds.,
  out=&out_ds.,
  outlib=&outlib.,
  label="Weighting file, &geo1dlbl to &geo2dlbl",
  sortby=&geo1. &geo2.,
  restrictions=None,
  revisions=%str(New file)
  )

  %exit_macro:

  ** Cleanup temporary files **;
  
  /*proc datasets library=work memtype=(data) nolist nowarn;
    delete _Block_pop &out_ds*/;
  quit;

%mend Calc_weights_from_blocks;

/** End Macro Definition **/
