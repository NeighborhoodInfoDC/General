************************************************************************
* Program:  Upload_wt_tr00_psa04.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  11/03/04
* Version:  SAS 8.2
* Environment:  Windows with SAS/Connect
* 
* Description:  Upload and register Wt_tr00_psa04 file (tract to PSA
* weighting file).
*
* Modifications:
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General )

** Start submitting commands to remote server **;

rsubmit;

** Upload file **;
/*
proc upload status=no
  data=General.Wt_tr00_psa04 
  out=General.Wt_tr00_psa04;

run;
*/
** Register with metadata **;

%DC_update_md_file( 
    ds_lib=General ,
    ds_name=Wt_tr00_psa04 ,
    creator_process=Wt_tr00_psa04.sas ,
    revisions=Creating file,
    restrictions=None,
    debug=y
  )

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
