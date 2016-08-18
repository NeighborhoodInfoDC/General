/**************************************************************************
 Program:  ANC2002.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/17/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Advisory Neighborhood Commission (2002) 
 names data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

** DBMS/Engines library to read DBF file **;

libname dbmsdbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4 width=12 dec=2;

** Create data set **;

data General.ANC2002 (label="List of DC Advisory Neighborhood Commissions (2002)");

  length ANC2002 $ 2 ANC2002_name $ 40;

  input ANC2002;
  
  ANC2002_name = "ANC " || ANC2002;
  
  label 
    ANC2002 = 'Advisory Neighborhood Commissions (2002)'
    ANC2002_name = 'Advisory Neighborhood Commissions (2002), name'
    ;
  
  datalines;
4A
3G
4B
3E
3F
4C
4D
5A
3D
5C
3C
1D
1A
3B
5B
1B
1C
2D
2E
7D
2B
2C
2F
7C
6C
2A
6A
7A
6B
7E
6D
7B
8A
8C
8B
8E
8D
;
  
run;

proc sort data=General.ANC2002;
  by ANC2002;

%file_info( data=General.ANC2002, printobs=100, stats= )



** Create formats **;

** $anc02a:  ANC xx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$anc02a,
  Data=General.ANC2002,
  Value=ANC2002,
  Label=ANC2002_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $anc02v:  
** Validation format - returns ANC number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$anc02v,
  Data=General.ANC2002,
  Value=ANC2002,
  Label=ANC2002,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


proc catalog catalog=general.formats entrytype=formatc;
  modify anc02a (desc="ANCs (2002), 'ANC nn'");
  modify anc02v (desc="ANCs (2002), validation");
  contents;
  quit;
  
** Add $anc02a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify ANC2002;
    format ANC2002 $anc02a.;
quit;

