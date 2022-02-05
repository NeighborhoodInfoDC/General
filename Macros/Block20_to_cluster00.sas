/**************************************************************************
 Macro:    Block20_to_cluster00
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 DC Neighborhood Clusters (2000).

 Modifications:
**************************************************************************/

%macro Block20_to_cluster00( invar=geoblk2020, outvar=Cluster2000, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk2cl0f. );
  
  label &outvar = "Neighborhood cluster (2000)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus00a.;
  %end;

%mend Block20_to_cluster00;



