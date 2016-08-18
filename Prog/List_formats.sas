/**************************************************************************
 Program:  List_formats.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/27/06
 Version:  SAS 8.2
 Environment:  Local Windows session (desktop)
 
 Description:  List formats in local General library.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

proc catalog catalog=Genera_r.formats;
  contents;

proc format library=Genera_r fmtlib;

run;
