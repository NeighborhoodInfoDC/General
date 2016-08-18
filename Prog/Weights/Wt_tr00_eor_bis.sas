/**************************************************************************
 Program:  Wt_tr00_eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create weighting file to convert 2000 tracts to EOR.

 Modifications:
**************************************************************************/

***%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "C:\DCData\SAS\Inc\Stdhead.sas";


** Define libraries **;
%DCData_lib( General )

** Merge with tract list to create full weighting file **;

data General.Wt_tr00_eor 
      (label="Weighting file, 2000 tracts to East of the Anacostia River"
       compress=no);

  set General.Geo2000 (keep=geo2000);

  eor = put( geo2000, $tr0eor. );
    
  popwt = 1;

  format eor $eor.;

  label
    geo2000 = "Census 2000 Tract ID: ssccctttttt"
    eor = "East of the Anacostia River"
    popwt = "Population weight";

run;

%File_info( data=General.Wt_tr00_eor, printobs=200, freqvars=eor )

