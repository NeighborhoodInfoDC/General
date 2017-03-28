/**************************************************************************
 Macro:    Tr00_to_eor
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/01/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert tract ID to EOR ID.

 Modifications:
**************************************************************************/

%macro Tr00_to_eor( tract=Geo2000, eor=Eor );

  length &eor $ 1;
  
  &eor = put( &tract, $tr0eor. );
  
  label &eor = "East of the Anacostia River";
  
  format &eor $eor.;

%mend Tr00_to_eor;



