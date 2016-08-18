/**************************************************************************
 Program:  Ward2002.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  2002 ward list data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data General.Ward2002 (label="List of DC wards (2002)" compress=no);

  input Ward2002 $1.;
  
  ward_label = 'Ward ' || Ward2002;
  
  label 
    ward2002 = 'Ward (2002)'
    ward_label = 'Ward (2002) label:  Ward n';

datalines;
1
2
3
4
5
6
7
8
;
  
run;

proc sort data=General.Ward2002;
  by Ward2002;

%file_info( data=General.Ward2002, printobs=190, stats= )

run;

** Create formats **;

** $ward02a:  Ward n **;

%Data_to_format(
  FmtLib=General,
  FmtName=$ward02a,
  Data=General.Ward2002,
  Value=Ward2002,
  Label=ward_label,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


** $ward02v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$ward02v,
  Data=General.Ward2002,
  Value=Ward2002,
  Label=Ward2002,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify ward02a (desc="Wards (2002), 'Ward n'");
  modify ward02v (desc="Wards (2002), validation");
  contents;
  quit;
  
** Add $ward02a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify ward2002;
    format ward2002 $ward02a.;
quit;

