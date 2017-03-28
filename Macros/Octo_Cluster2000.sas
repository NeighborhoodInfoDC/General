/**************************************************************************
 Macro:    Octo_Cluster2000
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO neighborhood cluster ID to
 NeighborhoodInfo DC standard var Cluster2000.

 Modifications:
**************************************************************************/

%macro Octo_Cluster2000( invar=Name, outvar=Cluster2000 );

  length &outvar $ 2;

  if upcase( &invar ) not in ( "", "NON-CLUSTER AREA" ) then
    &outvar = put( 1 * scan( &invar, 2 ), z2. );
  else
    &outvar = "99";

  label
    &outvar = "Neighborhood cluster (2000)";
    
%mend Octo_Cluster2000;



