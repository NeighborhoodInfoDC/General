/**************************************************************************
 Program:  Wt_tr80_tr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create tract reweighting file: 1980 to 2000.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

libname ncdbpub 'ncdb_public:';

data Wt_tr80_tr00 (label="Weighting file, 1980 tracts to 2000 tracts, DC/MD/VA/WV" compress=no);

  merge
    Ncdbpub.twt80_00 (where=(geo1980 in: ('11','24','51','54')))
    Ncdbpub.Ncdb_1980 (keep=statecd geo1980 where=(geo1980 in: ('11','24','51','54')))
    /*General.Geo1980 (keep=geo1980)*/;
  by geo1980;
  
  ** REMOVE EXTRANEOUS TRACT **;
  
  if geo1980 = "11001007299" then delete;
  
  if missing( weight ) then do;
    weight = 1;
    Tch80_00 = 0;
  end;
  
  format geo1980 ;
  format geo2000 $geo00a. ;
  
  rename weight=popwt;

run;

proc download status=no
  data=Wt_tr80_tr00 
  out=General.Wt_tr80_tr00 (compress=no);

run;

endrsubmit;

%file_info( data=General.Wt_tr80_tr00, freqvars=tch80_00 )

proc tabulate data=General.Wt_tr80_tr00 format=comma24.0 noseps missing;
  class statecd;
  var popwt;
  table statecd, popwt*sum='Sum';
  
run;

signoff;

