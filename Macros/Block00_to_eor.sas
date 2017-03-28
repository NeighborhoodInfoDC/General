/**************************************************************************
 Macro:    Block00_to_eor
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 East of the Anacostia River.

 Modifications:
  05/04/11 PAT Corrected variable length to 1.
**************************************************************************/

%macro Block00_to_eor( invar=geoblk2000, outvar=eor, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0eor. );
  
  label &outvar = "East of the Anacostia River";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $eor.;
  %end;

%mend Block00_to_eor;



