/**************************************************************************
 Macro:    Block00_to_cluster17
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  12/19/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to Cluster (2017).

 Modifications:
**************************************************************************/

%macro Block10_to_cluster17( invar=geoblk2010, outvar=cluster2017, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk1cl7f. );
  
  label &outvar = "Neighborhood Clusters (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus17a.;
  %end;

%mend Block10_to_cluster17;



