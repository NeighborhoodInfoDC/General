/**************************************************************************
 Macro:    Tr00_to_cta03
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/01/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert tract ID to Casey Target
 Area ID.

 Modifications:
**************************************************************************/

%macro Tr00_to_cta03( tract=Geo2000, cta=Casey_ta2003 );

  length &cta $ 1;
  
  &cta = put( &tract, $tr0cta. );
  
  label &cta = "Casey target area (2003)";
  
  format &cta $cta03f.;

%mend Tr00_to_cta03;



