/**************************************************************************
 Program:  Block20_eor.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/13/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 East of the River (EOR) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;


data Block20_eor 
       (label="Census 2020 blocks (GeoBlk2020) to East of the River (EOR) correspondence file"
        sortedby=GeoBlk2020);

  set GeoBlk2020;
  
  Eor = put( Geo2020, $tr1eor. );
  
  label eor = "East of the Anacostia River";

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
    printobs=5,
    freqvars=
  )
