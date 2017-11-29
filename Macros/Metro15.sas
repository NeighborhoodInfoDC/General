/**************************************************************************
 Macro:    Metro15
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/9/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Add 2015 metropolitan/micropolitan 
 statistical area code (METRO15).
 
 Modifications:
**************************************************************************/

%macro Metro15( ucountyv );

  ** Create 2015 metro variable from unique county ID **;

  length Metro15 $ 5;

  metro15 = put( &ucountyv, $ctym15f. );
  
  label metro15 = "Metropolitan/micropolitan statistical area (2015)";

%mend Metro15;



