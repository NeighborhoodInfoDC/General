/**************************************************************************
 Program:  Wt_tr80_tr00_dc.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create tract reweighting file: 1980 to 2000.

 Modifications:
**************************************************************************/

***%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

data General.Wt_tr80_tr00_dc (label="Weighting file, 1980 tracts to 2000 tracts, DC" compress=no);

  merge
    Ncdb.twt80_00_dc
    General.Geo1980 (keep=geo1980);
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

%file_info( data=General.Wt_tr80_tr00_dc, freqvars=tch80_00 )


