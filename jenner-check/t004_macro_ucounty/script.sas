/**************************************************************************
 Macro:    UCOUNTY  (compatibility bundle)
 Library:  General / Macros
 Project:  NeighborhoodInfo DC
 Author:   Peter A. Tatian

 Description:  Include file to create unique place ID (UCOUNTY) by
 concatenating the 2-digit FIPS state code and 3-digit county code.

 This bundle contains the %ucounty macro verbatim from
 Macros/ucounty.sas, followed by a small caller that exercises it
 against a handful of DC/MD/VA FIPS codes so the run is self-checking.
**************************************************************************/

/** Macro ucounty - verbatim from Macros/ucounty.sas **/

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

/** Caller: build unique county IDs from sample FIPS state/county codes **/

data counties;
  length statecd $ 2 countycd $ 3;
  input statecd $ countycd $;
  %ucounty( ucounty, Unique FIPS County ID:  ssccc, statecd, countycd )
datalines;
11 001
24 031
24 033
51 013
51 059
51 510
54 037
;
run;

proc print data=counties label;
  title "UCOUNTY: unique county ID from state + county FIPS";
run;
