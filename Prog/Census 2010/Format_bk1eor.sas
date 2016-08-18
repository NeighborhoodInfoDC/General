/**************************************************************************
 Program:  Format_bk1eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/04/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create format for converting 2010 blocks to EOR.
 
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

data Format;

  set General.GeoBlk2010;
  
  %tr10_to_eor()

run;

proc freq data=format;
  tables eor / missing;
run;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1eor,
  Desc="Block 2010 to EOR corresp",
  Data=Format,
  Value=geoblk2010,
  Label=eor,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=Y
  )

