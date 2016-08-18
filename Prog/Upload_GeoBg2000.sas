/**************************************************************************
 Program:  Upload_GeoBg2000.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/20/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register block group list file (GeoBg2000).

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
  select GeoBg2000;
run;

%Dc_update_meta_file(
  ds_lib=General,
  ds_name=GeoBg2000,
  creator_process=GeoBg2000.sas,
  restrictions=None,
  revisions=%str(New file.)
)

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
