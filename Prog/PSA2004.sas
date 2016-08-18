/**************************************************************************
 Program:  PSA2004.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/17/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Police Service Area (2004) 
 names data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

** DBMS/Engines library to read DBF file **;

libname dbmsdbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4 width=12 dec=2;

** Create data set **;

data General.PSA2004 (label="List of DC Police Service Areas (2004)");

  length PSA2004 $ 3 PSA2004_name $ 40 PSA2004_district $ 2;

  set dbmsdbf.PolSAPly;
  
  PSA2004 = name;
  
  PSA2004_name = "PSA " || PSA2004;
  
  PSA2004_district = poldist_id;
  
  label 
    PSA2004 = 'MPD Police Service Areas (2004)'
    PSA2004_name = 'MPD Police Service Areas (2004), name'
    PSA2004_district = 'MPD Police District (2004)'
    ;
  
  keep psa2004 psa2004_name psa2004_district;
  
run;

proc sort data=General.PSA2004;
  by PSA2004;

%file_info( data=General.PSA2004, printobs=100, stats= )

** Create formats **;

** $PSA04a:  PSA xx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$PSA04a,
  Data=General.PSA2004,
  Value=PSA2004,
  Label=PSA2004_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $PSA04v:  
** Validation format - returns PSA number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$PSA04v,
  Data=General.PSA2004,
  Value=PSA2004,
  Label=PSA2004,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


proc catalog catalog=general.formats entrytype=formatc;
  modify PSA04a (desc="PSAs (2004), 'PSA nn'");
  modify PSA04v (desc="PSAs (2004), validation");
  contents;
  quit;
  
** Add $PSA04a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify PSA2004;
    format PSA2004 $PSA04a.;
quit;

