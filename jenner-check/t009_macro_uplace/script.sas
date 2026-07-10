/**************************************************************************
 Macro: UPLACE  (compatibility bundle)
 Library:  General / Macros
 Project:  NeighborhoodInfo DC
 Author: Peter A. Tatian

 Description: Census 2000 - Include file to create the unique place ID
 (UPLACE98) by concatenating the 2-digit FIPS state code and the
 5-digit place code.

 This bundle contains the %uplace macro verbatim from Macros/uplace.sas,
 followed by a caller that exercises it against sample state/place codes
 (including a blank place, which the guard leaves unset).
**************************************************************************/

/** Macro uplace - verbatim from Macros/uplace.sas **/

%macro uplace( uplacev, varlbl, statev, placev );

length
  &uplacev $ 7
;

if &statev ~= "" and &placev ~= "" then
  &uplacev = &statev || &placev;

label
  &uplacev = "&varlbl"
;

%mend uplace;

/** Caller: build unique place IDs from sample state + place FIPS codes **/

data places;
  length statecd $ 2 placecd $ 5;
  input statecd $ placecd $;
  %uplace( uplace98, Unique FIPS Place ID:  ssppppp, statecd, placecd )
datalines;
11 50000
24 84775
51 48952
51
;
run;

proc print data=places label;
  title "UPLACE: unique place ID from state + place FIPS";
run;
