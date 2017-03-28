/**************************************************************************
 Macro:    Octo_ZIP
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO ZIP Code to
 NeighborhoodInfo DC standard var ZIP.

 Modifications:
**************************************************************************/

%macro Octo_ZIP( invar=Zipcode, outvar=Zip );

  ** ZIP code **;
  
  length &outvar $ 5;
  
  if &invar > 0 then 
    &outvar = put( &invar, z5. );
  else  
    &outvar = "";

  label
    &outvar = "ZIP code (5-digit)";
    
%mend Octo_ZIP;



