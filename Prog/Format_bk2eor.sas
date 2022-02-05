/**************************************************************************
 Program:  Format_bk2eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/04/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create format for converting 2020 blocks to EOR.
 
 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

data Format;

  set General.GeoBlk2020 (where=(geoblk2020 =: "11"));
  
  %tr20_to_eor()

run;

proc freq data=format;
  tables eor / missing;
run;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2eor,
  Desc="Block 2020 to EOR corresp",
  Data=Format,
  Value=geoblk2020,
  Label=eor,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=Y
  )

