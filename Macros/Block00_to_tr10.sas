/**************************************************************************
 Macro:    Block00_to_tr10
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/22/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Census tracts (2010).

 Modifications:
**************************************************************************/

%macro Block00_to_tr10( invar=geoblk2000, outvar=Geo2010, format=Y );

  length &outvar $ 11;
  
  &outvar = put( &invar, $bk0tr1f. );
  
  label &outvar = "Full census tract ID (2010): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo10a.;
  %end;

%mend Block00_to_tr10;



