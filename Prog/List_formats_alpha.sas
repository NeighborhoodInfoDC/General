/**************************************************************************
 Program:  List_formats_alpha.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/16/09
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  List formats in Alpha General library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General )

** Start submitting commands to remote server **;

rsubmit;

proc catalog catalog=General.formats;
  contents;

proc format library=General fmtlib;

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
