/**************************************************************************
 Macro:    Block20_to_vp12
 Library:  Macros
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  10/07/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert Census block IDs (2020) to
 Voting Precincts (2012).

 Modifications:
**************************************************************************/

%macro Block20_to_vp12( invar=geoblk2020, outvar=VoterPre2012, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk2vpaf.);
  
  label &outvar = "Voting Precinct (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $vote12a.;
  %end;

%mend Block20_to_vp12;



