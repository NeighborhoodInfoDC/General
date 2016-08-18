/* UCOUNTY.SAS - Census 2000
 *               Include file to create unique place ID (UCOUNTY)
 *
 *  05/30/01  Peter A. Tatian
 ****************************************************************************/

/** Macro ucounty - Start Definition **/

%macro ucounty( ucountyv, varlbl, statev, countyv );

length
  &ucountyv $ 5
;

if &statev ~= "" and &countyv ~= "" then
  &ucountyv = &statev || &countyv;

label
  &ucountyv = "&varlbl"
;

%mend ucounty;

/** End Macro Definition **/

