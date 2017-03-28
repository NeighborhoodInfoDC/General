/**************************************************************************
 Macro:    Block10_to_cluster00
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 DC Neighborhood Clusters (2000).

 Modifications:
**************************************************************************/

%macro Block10_to_cluster00( invar=geoblk2010, outvar=Cluster2000, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk1cl0f. );
  
  label &outvar = "Neighborhood cluster (2000)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus00a.;
  %end;

%mend Block10_to_cluster00;



