/**************************************************************************
 Macro:    GeoBlk2000_Octo  (compatibility bundle)
 Library:  Octo / Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian

 Description: Convert the NeighborhoodInfo DC standard var GeoBlk2000
 to the OCTO census block ID (cjrTractBl): strip the leading zeros off
 the 6-digit tract portion and append the 4-character block portion.

 This bundle contains the %GeoBlk2000_Octo macro verbatim from
 Macros/GeoBlk2000_Octo.sas, followed by a caller exercising the substr
 arithmetic against sample 15-character block IDs.
**************************************************************************/

/** Macro GeoBlk2000_Octo - verbatim from Macros/GeoBlk2000_Octo.sas **/

%macro GeoBlk2000_Octo( outvar=cjrTractBl, invar=GeoBlk2000 );

  length &outvar $ 254;

  if &invar ~= "" then do;

    &outvar = trim( left( put( 1 * substr( &invar, 6, 6 ), 6. ) ) ) || ' ' ||
              substr( &invar, 12, 4 );

  end;

  label
    &outvar = "OCTO census block ID (2000)";

%mend GeoBlk2000_Octo;

/** Caller: convert sample GeoBlk2000 block IDs to OCTO cjrTractBl **/

data blocks;
  length GeoBlk2000 $ 15;
  input GeoBlk2000 $;
  %GeoBlk2000_Octo( invar=GeoBlk2000, outvar=cjrTractBl )
datalines;
110010073011000
110010099072005
110010001001001
;
run;

proc print data=blocks label;
  title "GeoBlk2000_Octo: standard block ID to OCTO cjrTractBl";
run;
