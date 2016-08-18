/**************************************************************************
 Program:  Test_geo2000_octo.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/17/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Test correspondence between Geo2000 data set and OCTO
 Tract00Ply.dbf file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

libname dbmsdbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4 width=12 dec=2
  Tract00P=Tract00Ply;

proc sort data=dbmsdbf.Tract00P out=Tract00P;
  by name;
  
proc sort data=General.Geo2000 out=Geo2000;
  by tract_octo;

proc compare base=Geo2000 compare=Tract00P maxprint=(40,32000);
  var tract_octo;
  with name;

run;
