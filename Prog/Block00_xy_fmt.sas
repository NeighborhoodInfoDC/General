/**************************************************************************
 Program:  Block00_xy_fmt.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/22/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create formats for converting block ID to X & Y
 coordinates (NAD 1983 meters).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( OCTO )

libname Octo_dbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4
  block="Block00_Ward02";

data Block00_xy_fmt;

  set Octo_dbf.block (keep=CJRTRACTBL x y);
  
  %Octo_GeoBlk2000()

run;

proc sort data=Block00_xy_fmt nodupkey;
  by GeoBlk2000;

run;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0crdx,
  Data=Block00_xy_fmt,
  Value=GeoBlk2000,
  Label=put( x, 19.6 ),
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Desc="Block 2000 to X coord (MD NAD 83 meters)",
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0crdy,
  Data=Block00_xy_fmt,
  Value=GeoBlk2000,
  Label=put( y, 19.6 ),
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Desc="Block 2000 to Y coord (MD NAD 83 meters)",
  Contents=Y
  )

