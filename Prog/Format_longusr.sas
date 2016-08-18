/**************************************************************************
 Program:  Format_longusr.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/09/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Create format for correcting usernames for users with
 names longer than 8 characters. Needed to make Alpha emailing in 
 metadata system work for these users. Users must redownload the General
 library for this change to take effect.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Create $longusr format: 
**   Username limited to 8 chars = Full username;

proc format library=General;
  value $longusr
    'awilliam' = 'awilliams'
    'cnarducc' = 'cnarducci'
    'lgetsing' = 'lgetsinger'
    'rpitingo' = 'rpitingolo'
    'slitschw' = 'slitschwartz'
    'gmacdona' = 'gmacdonald'
  ;
run;

title2 'Local General format catalog';

proc catalog catalog=General.formats;
  modify longusr (desc="Convert short to long usernames.") / entrytype=formatc;
  contents;
quit;

proc format library=General fmtlib;
  select $longusr;
run;

** Start submitting commands to remote server **;

rsubmit;

title2 'Remote General format catalog';

proc upload status=no
	inlib=General
	outlib=General memtype=(catalog);
	select formats;
run;

proc catalog catalog=General.formats;
  contents;
quit;

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
