/**************************************************************************
 Macro:    Tr00_to_city
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert tract ID to city ID.

 Modifications:
**************************************************************************/

%macro Tr00_to_city( tract=Geo2000, city=city );

  length &city $ 1;
  
  &city = put( &tract, $tr0city. );
  
  label &city = "Washington, D.C.";
  
  format &city $city.;

%mend Tr00_to_city;



