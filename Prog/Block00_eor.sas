/**************************************************************************
 Program:  Block00_eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2000 blocks (GeoBlk2000) to 
 East of the River (EOR) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;


data General.Block00_eor 
       (label="Census 2000 blocks (GeoBlk2000) to East of the River (EOR) correspondence file"
        sortedby=GeoBlk2000);

  set General.GeoBlk2000;
  
  Eor = put( Geo2000, $tr0eor. );
  
  label eor = "East of the Anacostia River";

run;

%File_info( data=General.Block00_eor, printobs=40, stats=, freqvars=eor ) 

