/**************************************************************************
 Program:  Ward2012.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  2012 ward list data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

data General.Ward2012 (label="List of DC wards (2012)" compress=no);

  input Ward2012 $1.;
  
  ward_label = 'Ward ' || Ward2012;
  
  label 
    Ward2012 = 'Ward (2012)'
    ward_label = 'Ward (2012) label:  Ward n';

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

proc sort data=General.Ward2012;
  by Ward2012;

%file_info( data=General.Ward2012, printobs=190, stats= )

run;

** Create formats **;

** $ward12a:  Ward n **;

%Data_to_format(
  FmtLib=General,
  FmtName=$ward12a,
  Desc="Wards (2012), 'Ward n'",
  Data=General.Ward2012,
  Value=Ward2012,
  Label=ward_label,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


** $ward12v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$ward12v,
  Desc="Wards (2012), validation",
  Data=General.Ward2012,
  Value=Ward2012,
  Label=Ward2012,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** Add $ward12a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Ward2012;
    format Ward2012 $ward12a.;
quit;

