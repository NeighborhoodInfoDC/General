/**************************************************************************
 Program:  Tracts_2000_dc.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/15/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create list of 2000 census tracts for DC.  Add to metadata
 system.  Download file.

 Modifications:
  10/03/05 Adapted to use NCDB files on Alpha.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General )
%DCData_lib( NCDB )

rsubmit;

data General.Tracts_2000_dc (label="List of 2000 census tracts, DC" compress=no);

  set Ncdb.Ncdb_lf_2000_dc (keep=geo2000);

run;

proc sort data=General.Tracts_2000_dc;
  by geo2000;
  
run;

%Dc_update_meta_file(
  ds_lib=General,
  ds_name=Tracts_2000_dc,
  creator_process=Tracts_2000_dc,
  restrictions=None,
  revisions=%str(New file.)
)

run;

proc download status=no
  data=General.Tracts_2000_dc 
  out=General.Tracts_2000_dc;

run;

endrsubmit;

%File_info( data=General.Tracts_2000_dc, printobs=200 )

signoff;

