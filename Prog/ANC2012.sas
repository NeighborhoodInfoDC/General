/**************************************************************************
 Program:  ANC2012.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/27/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Advisory Neighborhood Commission (2012) 
 names data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;


** Create data set **;

data General.ANC2012 (label="List of DC Advisory Neighborhood Commissions (2012)");

  length ANC2012 $ 2 ANC2012_name $ 40;

  input ANC2012;
  
  ANC2012_name = "ANC " || ANC2012;
  
  label 
    ANC2012 = 'Advisory Neighborhood Commission (2012)'
    ANC2012_name = 'Advisory Neighborhood Commission (2012), name'
    ;
  
  datalines;
1A
1B
1C
1D
2A
2B
2C
2D
4C
3E
4B
2E
2F
3B
3C
3D
3F
3G
4A
6A
6B
6C
6D
6E
7B
7C
7D
7E
7F
8B
8C
8A
8D
8E
4D
5A
5B
5C
5D
5E
;
  
run;

proc sort data=General.ANC2012;
  by ANC2012;

%file_info( data=General.ANC2012, printobs=100, stats= )



** Create formats **;

** $anc12a:  ANC xx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$anc12a,
  Data=General.ANC2012,
  Value=ANC2012,
  Label=ANC2012_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $anc12v:  
** Validation format - returns ANC number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$anc12v,
  Data=General.ANC2012,
  Value=ANC2012,
  Label=ANC2012,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


proc catalog catalog=general.formats entrytype=formatc;
  modify anc12a (desc="ANCs (2012), 'ANC nn'");
  modify anc12v (desc="ANCs (2012), validation");
  contents;
  quit;
  
** Add $anc12a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify ANC2012;
    format ANC2012 $anc12a.;
quit;

