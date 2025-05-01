/**************************************************************************
 Macro:    Block10_to_anc23
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  05/01/25
 Version:  SAS 9.4
 Environment:  Windows 11
 
 Description: Convert Census block IDs (2010) to ANC (2023).

 Modifications:
**************************************************************************/

%macro Block10_to_anc23 ( invar=geoblk2010, outvar=ANC2023, format=Y );

  length &outvar $ 4;
  
  &outvar = put( &invar, $bk1an3f. );
  
  label &outvar = "Advisory Neighborhood Commission (2023)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc23a.;
  %end;

%mend Block10_to_anc23;



