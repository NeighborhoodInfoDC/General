/**************************************************************************
 Macro:    Block10_to_eor
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/04/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 East of the Anacostia River.

 Modifications:
**************************************************************************/

%macro Block10_to_eor( invar=geoblk2010, outvar=eor, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1eor. );
  
  label &outvar = "East of the Anacostia River";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $eor.;
  %end;

%mend Block10_to_eor;



