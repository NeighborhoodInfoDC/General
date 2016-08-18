/**************************************************************************
 Program:  Copy_census_formats.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/06/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Copy Census formats to General library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

%Concat_lib( cenfmts, D:\Data\Census2000\Formats )

proc catalog catalog=Cenfmts.formats;
  copy out=General.formats entrytype=formatc;
  select fstab fstdiv fstname fstreg plac98f;
quit;

proc catalog catalog=General.formats;
  contents;
quit;

run;
