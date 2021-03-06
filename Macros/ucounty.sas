/***************************************************************************
 * Macro: UCOUNTY
 * Description:  Include file to create unique place ID (UCOUNTY)
 *
 *  Created: 05/30/01  
 *  Author: Peter A. Tatian
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

