/**************************************************************************
 Macro:    Block10_to_vp12
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/06/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert Census block IDs (2010) to
 Voting Precincts (2012).

 Modifications:
**************************************************************************/

%macro Block10_to_vp12( invar=geoblk2010, outvar=VoterPre2012, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk1vpaf.);
  
  label &outvar = "Voting Precinct (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $vote12a.;
  %end;

%mend Block10_to_vp12;



