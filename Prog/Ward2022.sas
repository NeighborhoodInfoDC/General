/**************************************************************************
 Program:  Ward2022.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  02/09/2022
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  2022 ward list data set and formats.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

data Ward2022 (label="List of DC wards (2022)" compress=no);

  input Ward2022 $1.;
  
  ward_label = 'Ward ' || Ward2022;
  
  label 
    Ward2022 = 'Ward (2022)'
    ward_label = 'Ward (2022) label:  Ward n';

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

proc sort data=Ward2022;
  by Ward2022;

run;

  %Finalize_data_set(
    data=Ward2022,
    out=Ward2022,
    outlib=general,
    label="Wards (2022)",
    sortby=Ward2022,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )

** Create formats **;

** $ward22a:  Ward n **;

%Data_to_format(
  FmtLib=General,
  FmtName=$ward22a,
  Desc="Wards (2022), 'Ward n'",
  Data=Ward2022,
  Value=Ward2022,
  Label=ward_label,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $ward22v:  
** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$ward22v,
  Desc="Wards (2022), validation",
  Data=Ward2022,
  Value=Ward2022,
  Label=Ward2022,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )



** Add $ward22a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify Ward2022;
    format Ward2022 $ward22a.;
quit;

