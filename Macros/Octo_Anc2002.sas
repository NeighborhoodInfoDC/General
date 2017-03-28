/**************************************************************************
 Macro:    Octo_Anc2002
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO ANC ID to
 NeighborhoodInfo DC standard var Anc2002.

 Modifications:
**************************************************************************/

%macro Octo_Anc2002( invar=Name, outvar=Anc2002 );

  ** ANC code **;
  
  length &outvar $ 2;
  
  if &invar ~= "" then 
    &outvar = ANC_ID;
  else
    &outvar = "";
    
  label
    &outvar = "Advisory Neighborhood Commission (2002)";
    
%mend Octo_Anc2002;



