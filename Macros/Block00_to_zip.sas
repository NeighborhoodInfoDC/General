/**************************************************************************
 Macro:    Block00_to_zip
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/30/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 DC ZIP code.

 Modifications:
  03/21/11 PT  Added ZIP format. 
**************************************************************************/

%macro Block00_to_zip( invar=geoblk2000, outvar=Zip, format=Y );

  length &outvar $ 5;
  
  &outvar = put( &invar, $bk0zipf. );
  
  label &outvar = "ZIP code (5-digit)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $zipa.;
  %end;

%mend Block00_to_zip;



