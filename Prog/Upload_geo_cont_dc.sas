/**************************************************************************
 Program:  Upload_geo_cont_dc.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/05/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload DC geographic contiguity files 
 to Alpha and register metadata.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General )

rsubmit;

/** Macro Upload_geo - Start Definition **/

%macro Upload_geo( data=, revisions=New file. );

  proc upload status=no
  data=General.&data 
  out=General.&data (compress=no);

  run;
  
  x "purge [DCData.General.data]&data..*";
  
  run;
  
  %Dc_update_meta_file(
    ds_lib=General,
    ds_name=&data,
    creator_process=&data..sas,
    restrictions=None,
    revisions=%str(&revisions)
  )
  
  run;

%mend Upload_geo;

/** End Macro Definition **/

%Upload_geo( data=geo2000_cont_queen_dc )

run;

endrsubmit;

signoff;

