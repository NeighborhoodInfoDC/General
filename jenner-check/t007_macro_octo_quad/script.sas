/**************************************************************************
 Macro:    Octo_Quad  (compatibility bundle)
 Library:  Octo / Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian

 Description: Convert an OCTO quadrant ID to the NeighborhoodInfo DC
 standard var Quad: upcase and left-align, then blank anything that is
 not one of the four valid DC quadrants (NW, NE, SW, SE).

 This bundle contains the %Octo_Quad macro verbatim from
 Macros/Octo_Quad.sas, followed by a caller that exercises the upcase
 and the IN-list validation against clean, lowercase, and invalid input.
**************************************************************************/

/** Macro Octo_Quad - verbatim from Macros/Octo_Quad.sas **/

%macro Octo_Quad( invar=Quadrant, outvar=Quad );

  length &outvar $ 2;

  &outvar = left( upcase( &invar ) );

  if &outvar not in ( 'NW', 'NE', 'SW', 'SE' ) then &outvar = '';

  label
    &outvar = "DC quadrant";

%mend Octo_Quad;

/** Caller: normalize sample OCTO quadrant strings **/

data quads;
  length Quadrant $ 4;
  input Quadrant $;
  %Octo_Quad( invar=Quadrant, outvar=Quad )
datalines;
NW
ne
 sw
SE
XX
;
run;

proc print data=quads label;
  title "Octo_Quad: normalize and validate DC quadrant";
run;
