/**************************************************************************
 Program:  Wt_tr70_tr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/12/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create tract reweighting file: 1970 to 2000.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

libname ncdbpub 'ncdb_public:';

data Wt_tr70_tr00 (label="Weighting file, 1970 tracts to 2000 tracts, DC/MD/VA/WV" compress=no);

  merge
    Ncdbpub.twt70_00 
      (where=(geo1970 in: ('11','24','51','54')) 
       rename=(geo70=geo1970 geo00=geo2000))
    Ncdbpub.Ncdb_1970 (keep=statecd geo1970 where=(geo1970 in: ('11','24','51','54')));
  by geo1970;
  
  if missing( weight ) then do;
    weight = 1;
    Tch70_00 = 0;
  end;
  
  format geo1970 ;
  format geo2000 $geo00a. ;
  
  rename weight=popwt;

run;

proc download status=no
  data=Wt_tr70_tr00 
  out=General.Wt_tr70_tr00 (compress=no);

run;

endrsubmit;

%file_info( data=General.Wt_tr70_tr00, freqvars=tch70_00 )

proc tabulate data=General.Wt_tr70_tr00 format=comma24.0 noseps missing;
  class statecd;
  var popwt;
  table statecd, popwt*sum='Sum';
  
run;

signoff;

