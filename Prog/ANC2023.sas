/**************************************************************************
 Program:  ANC2023.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  04/30/25
 Version:  SAS 9.4
 Environment:  Windows 11
 
 Description:  Advisory Neighborhood Commission (2023) 
 names data set and formats.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;


** Create data set **;

data ANC2023 (label="List of DC Advisory Neighborhood Commissions (2023)");

  length ANC2023 $ 4 ANC2023_name $ 40;

  input ANC2023;
  
  ANC2023_name = "ANC " || ANC2023;
  
  label 
    ANC2023 = 'Advisory Neighborhood Commission (2023)'
    ANC2023_name = 'Advisory Neighborhood Commission (2023), name'
    ;
  
  datalines;
1A
1B
1C
1D
1E
2A
2B
2C
2D
2E
2F
2G
3/4G
3A
3B
3C
3D
3E
3F
4A
4B
4C
4D
4E
5A
5B
5C
5D
5E
5F
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
8A
8B
8C
8D
8E
8F

;
  
run;

proc sort data=ANC2023;
  by ANC2023;
run;

%Finalize_data_set(
	data=ANC2023,
	out=ANC2023,
	outlib=general,
	label="Advisory Neighborhood Commissions (2023)",
	sortby=ANC2023,
	/** Metadata parameters **/
	revisions=New file.,
	/** File info parameters **/
	printobs=8
)


** Create formats **;

** $anc23a:  ANC xx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$anc23a,
  Data=General.ANC2023,
  Value=ANC2023,
  Label=ANC2023_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $anc23v:  
** Validation format - returns ANC number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$anc23v,
  Data=General.ANC2023,
  Value=ANC2023,
  Label=ANC2023,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

  
** Add $anc23a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify ANC2023;
    format ANC2023 $anc23a.;
quit;

