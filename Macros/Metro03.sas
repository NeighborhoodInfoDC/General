/**************************************************************************
 Macro:    Metro03
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/22/04
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Add 2003 metropolitan/micropolitan 
 statistical area code (METRO03).
 
 Notes: Must have Cen2000 format library in FMTSEARCH.

 Modifications:
**************************************************************************/

%macro Metro03( ucountyv );

  ** Create 2003 metro variable from unique county ID **;

  length Metro03 $ 5;

  metro03 = put( &ucountyv, $ctym03f. );
  
  label metro03 = "Metropolitan/micropolitan statistical area (2003)";

%mend Metro03;



