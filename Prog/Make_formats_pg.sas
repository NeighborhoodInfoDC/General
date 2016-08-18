/**************************************************************************
 Program:  Make_formats_pg.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/15/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Make PG County geo formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

proc format library=General;

  value $pcd01a
    '1' = 'District 1'
    '2' = 'District 2'
    '3' = 'District 3'
    '4' = 'District 4'
    '5' = 'District 5'
    '6' = 'District 6'
    '7' = 'District 7'
    '8' = 'District 8'
    '9' = 'District 9';

  value $pcd01v
    '1' = '1'
    '2' = '2'
    '3' = '3'
    '4' = '4'
    '5' = '5'
    '6' = '6'
    '7' = '7'
    '8' = '8'
    '9' = '9';

run;

proc catalog catalog=General.formats;
  modify pcd01a (desc="PG council district, labels") / entrytype=formatc;
  modify pcd01v (desc="PG council district, validation") / entrytype=formatc;
  contents;
quit;

