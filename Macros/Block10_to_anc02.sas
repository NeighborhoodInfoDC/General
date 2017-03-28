/**************************************************************************
 Macro:    Block10_to_anc02
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 DC ANCs (2002).

 Modifications:
**************************************************************************/

%macro Block10_to_anc02( invar=geoblk2010, outvar=Anc2002, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk1an2f. );
  
  label &outvar = "Advisory Neighborhood Commission (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc02a.;
  %end;

%mend Block10_to_anc02;



