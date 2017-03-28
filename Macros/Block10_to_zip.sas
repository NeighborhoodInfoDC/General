/**************************************************************************
 Macro:    Block10_to_zip
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 DC ZIP code.

 Modifications:
**************************************************************************/

%macro Block10_to_zip( invar=geoblk2010, outvar=Zip, format=Y );

  length &outvar $ 5;
  
  &outvar = put( &invar, $bk1zipf. );
  
  label &outvar = "ZIP code (5-digit)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $zipa.;
  %end;

%mend Block10_to_zip;



