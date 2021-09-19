/**************************************************************************
 Macro:    Metro20
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  9/19/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  106
 
 Description: Add 2020 metropolitan/micropolitan 
 statistical area code (METRO20).
 
 Modifications:
**************************************************************************/

%macro Metro20( ucountyv );

  ** Create 2020 metro variable from unique county ID **;

  length Metro20 $ 5;

  metro20 = put( &ucountyv, $ctym20f. );
  
  label metro20 = "Metropolitan/micropolitan statistical area (2020)";

%mend Metro20;



