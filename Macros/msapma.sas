/* MSAPMA.SAS - Census 2000
 *                Include file to create MSAPMA99 variable.
 *
 *  11/03/03  Peter A. Tatian
 ****************************************************************************/

/** Macro msapma - Start Definition **/

%macro msapma( msapmav, varlbl, msacmav, pmsav );

  length &msapmav $ 4;

  if &pmsav in ( "", "9999" ) then &msapmav = &msacmav;
  else &msapmav = &pmsav;

  label &msapmav = "&varlbl";

%mend msapma;

/** End Macro Definition **/

