/**************************************************************************
 Program:  Wt_tr00_cta03.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create weighting file to convert 2000 tracts to 
 Casey target area (2003).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

** Merge with tract list to create full weighting file **;

data General.Wt_tr00_cta03 
      (label="Weighting file, 2000 tracts to 2003 Casey target area"
       compress=no);

  set General.Geo2000 (keep=geo2000);
  
  length casey_ta2003 $ 1;

  casey_ta2003 = put( geo2000, $tr0cta. );
    
  popwt = 1;

  format casey_ta2003 $cta03f.;

  label
    geo2000 = "Census 2000 Tract ID: ssccctttttt"
    casey_ta2003 = "Casey target area (2003)"
    popwt = "Population weight";

run;

%File_info( data=General.Wt_tr00_cta03, printobs=200, freqvars=casey_ta2003 )

