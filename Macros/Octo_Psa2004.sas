/**************************************************************************
 Macro:    Octo_Psa2004
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO PSA ID to
 NeighborhoodInfo DC standard var Psa2004.

 Modifications:
**************************************************************************/

%macro Octo_Psa2004( invar=Name, outvar=Psa2004 );

  ** PSA code **;
  
  length &outvar $ 3;
  
  if &invar ~= . then 
    &outvar = put( &invar, z3. );
  else  
    &outvar = "";

  label
    &outvar = "MPD Police Service Area (2004)";
    
%mend Octo_Psa2004;



