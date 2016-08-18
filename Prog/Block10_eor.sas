/**************************************************************************
 Program:  Block10_eor.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/07/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 East of the River (EOR) correspondence file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;


data General.Block10_eor 
       (label="Census 2010 blocks (GeoBlk2010) to East of the River (EOR) correspondence file"
        sortedby=GeoBlk2010);

  set General.GeoBlk2010;
  
  Eor = put( Geo2010, $tr1eor. );
  
  label eor = "East of the Anacostia River";

run;

%File_info( data=General.Block10_eor, printobs=40, stats=, freqvars=eor ) 

