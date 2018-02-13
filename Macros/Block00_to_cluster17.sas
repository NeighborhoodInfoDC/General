/**************************************************************************
 Macro:    Block00_to_cluster17
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  12/19/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to Cluster (2017).

 Modifications:
**************************************************************************/

%macro Block00_to_cluster17( invar=geoblk2000, outvar=cluster2017, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0cl7f. );
  
  label &outvar = "Neighborhood Cluster (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus17a.;
  %end;

%mend Block00_to_cluster17;



