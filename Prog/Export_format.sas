/**************************************************************************
 Program:  Export_format.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/28/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Export format to CSV file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

data Geoblk2010_to_Cluster_tr2000;

  set General.Geoblk2010 (keep=geoblk2010);
  
  %Block10_to_cluster_tr00()

  format geoblk2010 cluster_tr2000;

run;

proc print data=Geoblk2010_to_Cluster_tr2000;
run;

ENDSAS;

*ods csvall body="D:\DCData\Libraries\General\Prog\Export_format.csv";
ods html body="D:\DCData\Libraries\General\Prog\Export_format.html" style=Minimal;

proc format library=general fmtlib;
  select $bk0ct0f;

run;

ods html close;
