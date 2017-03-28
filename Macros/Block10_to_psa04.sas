/**************************************************************************
 Macro:    Block10_to_psa04
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 DC PSAs (2004).

 Modifications:
**************************************************************************/

%macro Block10_to_psa04( invar=geoblk2010, outvar=Psa2004, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk1ps4f. );
  
  label &outvar = "Police Service Area (2004)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa04a.;
  %end;

%mend Block10_to_psa04;



