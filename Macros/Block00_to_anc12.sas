/**************************************************************************
 Macro:    Block00_to_anc12
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 DC ANCs (2012).

 Modifications:
  08/28/12 PAT Corrected block to geo format name. 
**************************************************************************/

%macro Block00_to_anc12( invar=geoblk2000, outvar=Anc2012, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0anaf. );
  
  label &outvar = "Advisory Neighborhood Commission (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc12a.;
  %end;

%mend Block00_to_anc12;



