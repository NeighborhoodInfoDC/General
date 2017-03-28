/**************************************************************************
 Macro:    Block00_to_casey_nbr2003
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Casey target area neighborhood (2003).

 Modifications:
**************************************************************************/

%macro Block00_to_casey_nbr2003( invar=geoblk2000, outvar=casey_nbr2003, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0cn3f. );
  
  label &outvar = "Casey target area neighborhood (2003)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $cnb03f.;
  %end;

%mend Block00_to_casey_nbr2003;



