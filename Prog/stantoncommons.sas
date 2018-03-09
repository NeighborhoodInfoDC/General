/**************************************************************************
 Program:  stantoncommons.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  3/7/18
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Custom geography of stantoncommons names data set and formats.

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data StantonCommons (label="List of Custom Stanton Commons Geographies"
);

  input stantoncommons $1. stantoncommons_name & $99.;

  label 
    stantoncommons = 'Stanton Commons (2018)'
    stantoncommons = 'Stanton Commons (2018) Name';

datalines;
1 Stanton Commons Catchment Area
2 Ward 8 excluding Stanton Commons
3 Washington DC excluding Ward 8
;
  
run;

**sort procedure changed the right order?**;
proc sort data=stantoncommons;
  by stantoncommons;
run;


** Create formats **;

** $StantonCommons:  NeiName **;

%Data_to_format(
  FmtLib=General,
  FmtName=$stanca,
  Data=StantonCommons,
  Value=StantonCommons,
  Label=StantonCommons_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $stancv.:  
** Validation format - returns stantoncommons number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$stancv
,
  Data=stantoncommons,
  Value=stantoncommons,
  Label=StantonCommons2018,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=general.formats entrytype=formatc;
  modify stanca (desc="Stanton Commons (2018), Area Names");
  modify stancv (desc="Stanton Commons (2018), validation");
  contents;
  quit;

** Add $stanca format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify StantonCommons;
    format StantonCommons $stanca.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=StantonCommons,
  out=StantonCommons,
  outlib=General,
  label="List of Custom Stanton Commons Geographies",
  sortby=stantoncommons,
  restrictions=None,
  revisions=New File.
  );

%file_info( data=General.stantoncommons, printobs=5, stats= )


/* End of Program */

