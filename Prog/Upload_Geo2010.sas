/**************************************************************************
 Program:  Upload_Geo2010.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  2/21/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register 2010 tract list file (Geo2010).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;


** Start submitting commands to remote server **;

rsubmit;

proc upload status=no
  inlib=General 
  outlib=General memtype=(data);
  select Geo2010;
run;

%Dc_update_meta_file(
  ds_lib=General,
  ds_name=Geo2010,
  creator_process=Geo2010.sas,
  restrictions=None,
  revisions=%str(New file.)
)

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
