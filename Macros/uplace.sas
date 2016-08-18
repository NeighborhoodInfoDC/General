/* UPLACE.SAS - Census 2000
 *                Include file to create unique place ID (UPLACE98)
 *
 *  05/30/01  Peter A. Tatian
 ****************************************************************************/

/** Macro uplace - Start Definition **/

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

/** End Macro Definition **/

