/**************************************************************************
 Program:  Format_longusr.sas  (compatibility bundle)
 Library:  General
 Project:  NeighborhoodInfo DC

 Description:  Create $longusr format for correcting usernames for users
 with names longer than 8 characters and to translate SAS1 server
 usernames (dcdata_xxx) for all users.

 Adapted from Prog/Format_longusr.sas: the format builds into WORK (the
 original targets the Genera_r catalog) and the run prints it so the
 listing is self-checking. The value block below is verbatim from the
 repository.
**************************************************************************/

proc format library=work;
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

** Print the format so the run verifies the username translations built **;

proc format library=work fmtlib;
  select $longusr;
run;
