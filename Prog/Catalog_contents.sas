/**************************************************************************
 Program:  Catalog_contents.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/21/07
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  List contents of Alpha General formats catalog.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;

** Start submitting commands to remote server **;

rsubmit;

proc catalog catalog=General.formats;
  contents;

quit;


run;

endrsubmit;

** End submitting commands to remote server **;




run;

signoff;
