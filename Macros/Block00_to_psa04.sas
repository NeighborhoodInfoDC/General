/**************************************************************************
 Macro:    Block00_to_psa04
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/30/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 DC PSAs (2004).

 Modifications:
**************************************************************************/

%macro Block00_to_psa04( invar=geoblk2000, outvar=Psa2004, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk0ps4f. );
  
  label &outvar = "Police Service Area (2004)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa04a.;
  %end;

%mend Block00_to_psa04;



