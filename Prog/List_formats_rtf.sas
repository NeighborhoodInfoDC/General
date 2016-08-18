/**************************************************************************
 Program:  List_formats_rtf.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  List all General formats in RTF file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

** List of formats in catalog **;

ods trace on;

ods output Catalog_Random=Catalog;

ods listing close;

proc catalog catalog=General.Formats;
  contents;

quit;

run;

ods output close;

ods listing;

ods trace off;

** List of format definitions **;

ods trace on;

ods output format=Format;

ods listing close;

proc format library=General fmtlib;

run;

ods output close;

ods listing;

proc print data=Format (obs=200);

run;

ods trace off;

** Write catalog to RTF file **;

data Catalog2;

  set Catalog;
  
  length format_name $ 32;
  
  if type = "FORMATC" then format_name = '$' || lowcase(objname);
  else format_name = lowcase(objname);
  
  date = datepart( moddate );
  
  label 
    date = 'Date updated'
    format_name = 'Format'
    desc = 'Description';
    
  format date mmddyy8.;
    
run;

proc sort data=Catalog2;
  by objname;

%fdate()

options nodate nonumber;
 
ods rtf file="&_dcdata_path\General\Doc\List_formats.rtf" style=Rtf_arial_9pt;

proc print data=Catalog2 label;
  id format_name;
  var date desc;
  title "DCData General Library:  List of Formats (&fdate)";
  footnote1 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

ods rtf close;
