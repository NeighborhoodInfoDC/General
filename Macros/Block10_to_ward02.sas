/**************************************************************************
 Macro:    Block10_to_ward02
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 DC wards (2002).

 Modifications:
**************************************************************************/

%macro Block10_to_ward02( invar=geoblk2010, outvar=Ward2002, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk1wd2f. );
  
  label &outvar = "Ward (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $ward02a.;
  %end;

%mend Block10_to_ward02;



