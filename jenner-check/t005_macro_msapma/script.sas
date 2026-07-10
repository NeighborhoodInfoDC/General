/**************************************************************************
 Macro: MSAPMA  (compatibility bundle)
 Library:  General / Macros
 Project:  NeighborhoodInfo DC
 Author: Peter A. Tatian

 Description: Census 2000 - Include file to create MSAPMA99 variable:
 use the PMSA code when present, otherwise fall back to the MSA/CMSA code.

 This bundle contains the %msapma macro verbatim from Macros/msapma.sas,
 followed by a small caller that exercises the PMSA-vs-MSA/CMSA fallback
 against sample area codes so the run is self-checking.
**************************************************************************/

/** Macro msapma - verbatim from Macros/msapma.sas **/

%macro msapma( msapmav, varlbl, msacmav, pmsav );

  length &msapmav $ 4;

  if &pmsav in ( "", "9999" ) then &msapmav = &msacmav;
  else &msapmav = &pmsav;

  label &msapmav = "&varlbl";

%mend msapma;

/** Caller: derive MSAPMA99 from sample MSA/CMSA and PMSA codes **/

data areas;
  length msacma $ 4 pmsa $ 4;
  input msacma $ pmsa $;
  %msapma( msapma99, MSA/PMSA (1999), msacma, pmsa )
datalines;
8872 8840
8872 9999
8872
7040 6740
1122 1123
;
run;

proc print data=areas label;
  title "MSAPMA: PMSA when present, else MSA/CMSA code";
run;
