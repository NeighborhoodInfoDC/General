/**************************************************************************
 Program:  PSA2012.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/27/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Police Service Area (2012) 
 names data set and formats.

 Modifications:EN 11/13/2019
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;


** Read PSA info from exported CSV of shapefile PolSAPly12 **;

filename fimport "D:\DCData\Libraries\OCTO\Maps\PolSAPly12.csv" lrecl=2000;

proc import out=PolSAPly12
    datafile=fimport
    dbms=csv replace;
  datarow=2;
  getnames=yes;

run;

** Create data set **;

data General.PSA2012 (label="List of DC MPD Police Service Areas (2012)");

  length PSA2012 $ 3 PSA2012_name $ 40 PSA2012_district $ 2;

  set PolSAPly12;
  
  PSA2012 = name;
  
  PSA2012_name = "PSA " || PSA2012;
  
  PSA2012_district = put( poldist_id, 1. ) || 'D';
  
  label 
    PSA2012 = 'Police Service Area (2012)'
    PSA2012_name = 'Police Service Area (2012), name'
    PSA2012_district = 'MPD Police District (2012)'
    ;
  
  keep psa2012 psa2012_name psa2012_district;
  
run;

proc sort data=General.PSA2012;
  by PSA2012;

%file_info( data=General.PSA2012, printobs=100, stats= )

** Create formats **;

** $PSA12a:  PSA xx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$PSA12a,
  Data=General.PSA2012,
  Value=PSA2012,
  Label=PSA2012_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $PSA12v:  
** Validation format - returns PSA number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$PSA12v,
  Data=General.PSA2012,
  Value=PSA2012,
  Label=PSA2012,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


proc catalog catalog=general.formats entrytype=formatc;
  modify PSA12a (desc="PSAs (2012), 'PSA nn'");
  modify PSA12v (desc="PSAs (2012), validation");
  contents;
  quit;
  
** Add $PSA12a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify PSA2012;
    format PSA2012 $PSA12a.;
quit;

