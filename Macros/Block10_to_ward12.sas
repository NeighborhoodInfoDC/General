/**************************************************************************
 Macro:    Block10_to_ward12
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 DC wards (2012).

 Modifications:
**************************************************************************/

%macro Block10_to_ward12( invar=geoblk2010, outvar=Ward2012, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1wdaf. );
  
  label &outvar = "Ward (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $ward12a.;
  %end;

%mend Block10_to_ward12;



