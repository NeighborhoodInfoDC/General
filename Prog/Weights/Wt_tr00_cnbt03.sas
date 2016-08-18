/**************************************************************************
 Program:  Wt_tr00_cnbt03.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/15/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create weighting file to convert 2000 tracts to 
 Casey targeted neighborhoods, total area (casey_nbt2003).

   1 = Outside Casey targeted neighborhoods
   9 = Outside targeted neighborhoods

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data tractlist (compress=no);

  length casey_nbt2003 $ 1 GEO2000 $ 11 ;

  input casey_nbt2003 geo2000;

cards;
1 11001007804
1 11001007808
1 11001009903
1 11001009904
1 11001009905
1 11001009906
1 11001007703
1 11001007707
1 11001009907
;

run;

proc sort data=tractlist;
  by geo2000;

run;

** Merge with tract list to create full weighting file **;

data General.Wt_tr00_cnbt03 
      (label="Weighting file, 2000 tracts to 2003 Casey targeted neighborhoods (total area)"
       compress=no);

  merge tractlist General.Tracts_2000_dc;
    by geo2000;
    
  if casey_nbt2003 = "" then 
    casey_nbt2003 = "9";

  popwt = 1;

  format casey_nbt2003 $cnbt03f.;

  label
    geo2000 = "Census 2000 Tract ID: ssccctttttt"
    casey_nbt2003 = "Casey targeted neighborhoods, total area (2003)"
    popwt = "Population weight";

run;

%File_info( data=General.Wt_tr00_cnbt03, printobs=200, freqvars=casey_nbt2003 )

