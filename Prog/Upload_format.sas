/**************************************************************************
 Program:  Upload_format.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/26/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload formats to ALPHA General library.

 Modifications:
  02/16/17 JD	Updated to run on L:\ Drive.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";
*%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

rsubmit;

** Delete old formats **;
/*
proc catalog catalog=General.Formats;
  delete bk0wdaf bk0wdbf bk1wdaf bk1wdbf / entrytype=formatc;
quit;
*/

** Upload local catalog to Alpha **;

proc upload status=no
	inlib=General
	outlib=General memtype=(catalog);
	select formats;
	
run;

x "purge [dcdata.General.data]formats.*";

proc catalog catalog=General.formats;
  contents;

run;

endrsubmit;

run;

signoff;
