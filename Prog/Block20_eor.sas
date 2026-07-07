/**************************************************************************
 Program:  Block20_eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/07/14
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 East of the River (EOR) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;


data Block20_eor;

  set General.GeoBlk2020;
  where state = '11';
  
  Eor = put( Geo2020, $tr2eor. );
  
  label Eor = "East of the Anacostia River";

run;

%Finalize_data_set(
    data=Block20_eor,
    out=Block20_eor,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to East of the River (EOR) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=25,
    stats=,
    freqvars=Eor
  )

