/**************************************************************************
 Macro:    Block20_to_cluster17
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to Cluster (2017).

 Modifications:
**************************************************************************/

%macro Block20_to_cluster17( invar=geoblk2020, outvar=cluster2017, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk2cl7f. );
  
  label &outvar = "Neighborhood Clusters (2017)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $c1us17a.;
  %end;

%mend Block20_to_cluster17;



