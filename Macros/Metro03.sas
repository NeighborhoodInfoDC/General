/* Metro03.sas - Census 2000
 *
 * Autocall macro to add 2003 metropolitan/micropolitan statistical
 * area code (METRO03).
 * 
 * NB:  Must have Cen2000 format library in FMTSEARCH.
 *
 * NB:  Program written for SAS Version 8.2
 *
 * 07/22/04  Peter A. Tatian
 ****************************************************************************/

/** Macro Metro03 - Start Definition **/

%macro Metro03( ucountyv );

  ** Create 2003 metro variable from unique county ID **;

  length metro03 $ 5;

  metro03 = put( &ucountyv, $ctym03f. );
  
  label metro03 = "Metropolitan/micropolitan statistical area (2003)";

%mend Metro03;

/** End Macro Definition **/

