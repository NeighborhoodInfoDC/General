/**************************************************************************
 Macro:    Block20_to_eor
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/05/22
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 East of the Anacostia River.

 Modifications:
**************************************************************************/

%macro Block20_to_eor( invar=geoblk2020, outvar=eor, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk2eor. );
  
  label &outvar = "East of the Anacostia River";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $eor.;
  %end;

%mend Block20_to_eor;



