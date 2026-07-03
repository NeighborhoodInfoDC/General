/**************************************************************************
 Macro:    Create_all_summary_from_tracts
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/29/06
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create all summary level files from a tract level summary file.

 Modifications:
  08/27/06 PAT Added REVISIONS= parameter.
  09/26/06 PAT Added LIB= parameter.
  12/22/10 PAT Added MPRINT= parameter.
  07/14/12 PAT Removed casey_nbr2003 and casey_ta2003 from list of geos.
               Added Anc2012, Ward2012, and Psa2010.
               Added TRACT_YR= parameter for specifying source tract year.
               DISABLED ALL GEOS EXCEPT WARDS FOR TESTING.
  07/21/12 PAT Added tract-level summary for 2010 (if based on 2000 tracts)
               or for 2000 (if based on 2010).
  09/09/12 PAT Final production version for all geos.
  12/17/12 PAT Added summary for voting precincts (VoterPre2012).
  03/28/17     Added summary for Bridge Park impact area (BridgePk)
  03/15/18 NS  Added summary for Cluster 2017.
  05/16/18 YS  Add summary for StantonCommons
  05/25/22 EB  Add summary for ward2022
  07/03/26 PT  Add state_filter= parameter. Fix tract transformations.
               Add ANC2023, PSA2019 summaries. 
               Remove stantoncommons, bridgepk summaries.
**************************************************************************/

%macro Create_all_summary_from_tracts( 
  lib=,               /** Input and output library name **/
  data_pre=,          /** Data set prefix (input and output) **/
  data_label=,        /** Output data set label text **/
  count_vars=,        /** List of variables that are counts **/
  prop_vars=,         /** List of variables that are proportions **/
  calc_vars=,         /** Specifications for calculated variables **/
  calc_vars_labels=,  /** Labels for calculated vars **/
  tract_yr=2000,      /** Input data set tract year (2000, 2010, or 2020) **/
  register=,          /** Register data sets with metadata [DEPRECATED] **/
  finalize=y,         /** Create final data sets on final batch submit **/
  creator_process=,   /** Specify creator process for metadata (optional) **/
  restrictions=,      /** Restrictions on output data sets for metadata **/
  revisions=,         /** Revisions label for metadata **/
  mprint=n,           /** Macro MPRINT option **/
  include_tracts=y,   /** Include tract transformations in output data sets **/
  state_filter=       /** FIPS codes to filter output data for tract transformation data sets (in quotes, optional) **/
);

  %Create_summary_from_tracts( geo=city, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=eor, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=ward2002, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=ward2012, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

 %Create_summary_from_tracts( geo=ward2022, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=zip, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=psa2004, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=psa2012, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=psa2019, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=anc2002, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=anc2012, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=anc2023, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=cluster_tr2000, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=cluster2017, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=voterpre2012, 
    lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
    
%if %mparam_is_yes( &include_tracts ) %then %do;
  %if &tract_yr = 2000 %then %do;
    %Create_summary_from_tracts( geo=geo2010, state_filter=&state_filter,
      lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
      prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
      tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
      restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
  %end;
  %else %if &tract_yr = 2010 %then %do;
    %Create_summary_from_tracts( geo=geo2000, state_filter=&state_filter, 
      lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
      prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
      tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
      restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
    %Create_summary_from_tracts( geo=geo2020, state_filter=&state_filter,
      lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
      prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
      tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
      restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
  %end;
  %else %if &tract_yr = 2020 %then %do;
    %Create_summary_from_tracts( geo=geo2010, state_filter=&state_filter,
      lib=&lib, outlib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
      prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
      tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
      restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
  %end;
%end;

%mend Create_all_summary_from_tracts;

