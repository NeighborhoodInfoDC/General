/**************************************************************************
 Program:  Download_general_lib.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download entire DCData General library (data sets &
 formats) from Alpha.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;

rsubmit;

options compress=no;

proc download status=no
  inlib=General 
  outlib=General memtype=(all);

run;

options compress=yes;

run;

endrsubmit;


**--------------------------------------------------**;
title2 "Contents of local General library";

proc sql;
   describe table dictionary.members; 
   select memname, memtype, engine
      from dictionary.members
      where libname='GENERAL'; 
quit;

proc catalog catalog=General.formats;
  contents;
quit;

run;

title2;

signoff;
