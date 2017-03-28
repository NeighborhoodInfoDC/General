/**************************************************************************
 Macro:    Tr00_to_cnb03
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/01/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert tract ID to 
 Casey Target Neighborhoods ID.

 Modifications:
**************************************************************************/

%macro Tr00_to_cnb03( tract=Geo2000, cnb=Casey_nbr2003 );

  length &cnb $ 1;
  
  &cnb = put( &tract, $tr0cnb. );
  
  label &cnb = "Casey target area neighborhood (2003)";
  
  format &cnb $cnb03f.;

%mend Tr00_to_cnb03;



