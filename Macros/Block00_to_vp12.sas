/**************************************************************************
 Macro:    Block00_to_vp12
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/06/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2000) to
 Voting Precincts (2012).
**************************************************************************/

%macro Block00_to_vp12 ( invar=geoblk2000, outvar=VoterPre2012, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk0vpaf.);
  
  label &outvar = "Voting Precinct (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $vote12a.;
  %end;

%mend Block00_to_vp12;



