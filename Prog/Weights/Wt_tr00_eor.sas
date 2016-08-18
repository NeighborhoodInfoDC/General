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
   07/21/12 PAT Use new %Calc_weights_from_blocks macro, add Popwt_prop.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Census )

/*
** Merge with tract list to create full weighting file **;

data General.Wt_tr00_eor 
      (label="Weighting file, 2000 tracts to East of the Anacostia River"
       sortedby=Geo2000
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

*/

%Calc_weights_from_blocks( 
  geo1 = Geo2000, 
  geo2 = Eor,
  out_ds = Wt_tr00_Eor,
  block_corr_ds = General.Block00_Eor, 
  block = GeoBlk2000,
  block_pop_ds = Census.Cen2000_sf1_dc_blks,  
  block_pop_var = pop100, 
  block_pop_year = 2000
)

** Test against previous version **;

libname save "D:\DCData\Libraries\General\Data\Save";

proc sort data=Save.Wt_tr00_Eor out=Wt_tr00_Eor;
  by Geo2000 Eor;

proc compare base=Wt_tr00_Eor compare=General.Wt_tr00_Eor maxprint=(40,32000);
  id Geo2000 Eor;
  var Popwt;
  with Popwt;
run;

