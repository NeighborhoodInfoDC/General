/**************************************************************************
 Program:  NPA2019.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  12/12/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  DC PSA names data set and formats.

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data NPA2019 (label="Neighborhood Planning Areas (2019)");

  input npa2019 $1. npa2019_name & $10.; 

  label 
    psa2019 = 'Neighborhood Planning Areas (2019)'
    psa2019_name = 'Neighborhood Planning Areas (2019) Name';

datalines;
1	Downtown
2 	Eastern
3	Southern
4	Western
5	Northern
;
  
run;

**sort procedure changed the right order?**;
proc sort data=npa2019;
  by npa2019;
run;


** Create formats **;

** $npa2019a: npa nn **;

%Data_to_format(
  FmtLib=General,
  FmtName=$npa19a,
  Data=NPA2019,
  Value=NPA2019,
  Label="Neighborhood Planning Area" || npa2019,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


** $npa2019b:  NeiName **;

%Data_to_format(
  FmtLib=General,
  FmtName=$npa19b,
  Data=NPA2019,
  Value=npa2019,
  Label=npa2019_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $npa19f: npa nn (...) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$npa19f,
  Data=NPA2019,
  Value=npa2019,
  Label="Neighborhood Planning Area " || trim( npa2019 ) || " (" || trim( npa2019_name ) || ")",
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $npa17g: nn (...) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$npa19g,
  Data=NPA2019,
  Value=NPA2019,
  Label=trim( PSA2019 ) || " (" || trim( npa2019_name ) || ")",
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


** $npa17v:  
** Validation format - returns NPA2019 number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$npa19v,
  Data=NPA2019,
  Value=NPA2019,
  Label=NPA2019,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=General.formats entrytype=formatc;
  modify npa19a (desc="Neighborhood Planning Areas (2019)), 'npa nn'");
  modify npa19b (desc="Neighborhood Planning Areas (2019), npa names only");
  modify npa19f (desc="Neighborhood Planning Areas (2019), 'npa nn (..)'");
  modify npa19g (desc="Neighborhood Planning Areas (2019), 'nn (..)'");
  modify npa19v (desc="Neighborhood Planning Areas (2019), validation");
  contents;
  quit;

** Add $npa19a format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify npa2019;
    format npa2019 $npa19a.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=NPA2019,
  out=npa2019,
  outlib=General,
  label="Neighborhood Planning Areas (2019)",
  stats=,
  sortby=npa2019,
  restrictions=None,
  revisions=Added new cluster display formats.
  );


/* End of Program */

