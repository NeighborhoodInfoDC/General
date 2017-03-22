/**************************************************************************
 Program:  Format_longusr.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/09/10
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create format for correcting usernames for users with
 names longer than 8 characters and to translate SAS1 server usernames
 (dcdata_xxx) for all users.
 
 NOTES: 
 - Past users SHOULD NEVER BE REMOVED from this format. 
 - Use the full (long) username on the right of the = sign 
   (ex: "awilliams", not "awilliam"). 
 - New users should also be added to the $creator format in program
   L:\Libraries\Metadata\Prog\Creator_format.sas.

 Modifications:
   02/03/13 PAT Revised for use with SAS1 server.
   07/03/14 PAT Added dcdata_rp.
   07/27/14 PAT Added kabazaji, dcdata_kaa, dcdata_bl.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Create $longusr format: 
**   Username limited to 8 chars = Full username;

proc format library=Genera_r;
  value $longusr
    /** Convert short usernames (for people with full usersnames longer than 8 chars **/
    'awilliam' = 'awilliams'
    'cnarducc' = 'cnarducci'
    'lgetsing' = 'lgetsinger'
    'rpitingo' = 'rpitingolo'
    'slitschw' = 'slitschwartz'
    'gmacdona' = 'gmacdonald'
    'mwoluche' = 'mwoluchem'
    'kabazaji' = 'kabazajian'
    /** Convert SAS1 server usernames (for all SAS1 users) **/
    'dcdata_ksp' = 'kpettit'
    'dcdata_pat' = 'ptatian'
    'dcdata_dsd' = 'ddorio'
    'dcdata_lh' = 'lhendey'
    'dcdata_zm' = 'zmcdade'
    'dcdata_rag' = 'rgrace'
    'dcdata_rmp' = 'rpitingolo'
    'dcdata_rp' = 'rpitingolo'
    'dcdata_gm' = 'gmacdonald'
    'dcdata_bl' = 'blosoya'
    'dcdata_bjl' = 'blosoya'
    'dcdata_msw' = 'mwoluchem'
    'dcdata_eno' = 'eoo'
    'dcdata_kaa' = 'kabazajian'
  ;
run;

title2 'General format catalog';

proc catalog catalog=Genera_r.formats;
  modify longusr (desc="Convert short to long usernames.") / entrytype=formatc;
  contents;
quit;

proc format library=Genera_r fmtlib;
  select $longusr;
run;

