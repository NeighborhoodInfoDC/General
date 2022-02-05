/**************************************************************************
 Macro:    Tr20_to_eor
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/05/22
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert 2020 tract ID to EOR ID.

 Modifications:
**************************************************************************/

%macro Tr20_to_eor( tract=Geo2020, eor=Eor );

  length &eor $ 1;
  
  &eor = put( &tract, $tr2eor. );
  
  label &eor = "East of the Anacostia River";
  
  format &eor $eor.;

%mend Tr20_to_eor;



