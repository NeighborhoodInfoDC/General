/**************************************************************************
 Program:  Cimport_library.sas
 Library:  -
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/04/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Extract library from transport file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

%let lib = GTest;

** Define libraries **;
%DCData_lib( &lib )

filename tranfile "D:\DCData\Libraries\&lib\Data\cport_&lib..cpt";

proc cimport library=&lib infile=tranfile;
run;

filename tranfile clear;

run;
