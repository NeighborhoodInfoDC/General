/**************************************************************************
 Program:  Register_Wt_bg00_all.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/20/10
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Register all block group weighting files in metadata.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;


rsubmit;

/** Macro Register - Start Definition **/

%macro Register( data=, revisions=New file., creator_process=Wt_bg00_all.sas );

  %Dc_update_meta_file(
    ds_lib=General,
    ds_name=&data,
    creator_process=&creator_process,
    restrictions=None,
    revisions=%str(&revisions)
  )
  
  run;

%mend Register;

/** End Macro Definition **/

%Register( data=wt_bg00_anc02 )
%Register( data=wt_bg00_city )
%Register( data=wt_bg00_cl00 )
%Register( data=wt_bg00_cltr00 )
%Register( data=wt_bg00_cnb03 )
%Register( data=wt_bg00_cta03 )
%Register( data=wt_bg00_eor )
%Register( data=wt_bg00_psa04 )
%Register( data=wt_bg00_tr00 )
%Register( data=wt_bg00_ward02 )
%Register( data=wt_bg00_zip )

run;

endrsubmit;

signoff;

