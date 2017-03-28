/**************************************************************************
 Macro:    Block00_to_casey_ta2003
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Casey target area (2003).

 Modifications:
**************************************************************************/

%macro Block00_to_casey_ta2003( invar=geoblk2000, outvar=Casey_ta2003, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0ca3f. );
  
  label &outvar = "Casey target area (2003)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $cta03f.;
  %end;

%mend Block00_to_casey_ta2003;



