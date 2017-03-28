/**************************************************************************
 Macro:    Octo_VoterPre2012
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/05/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Convert OCTO Name var to
 NeighborhoodInfo DC standard var VoterPre2012.

 Modifications:
**************************************************************************/

%macro Octo_VoterPre2012( 
  invar=Name,   /** Input var name **/
  outvar=VoterPre2012, /** Output var name **/
  check=n         /** Perform validity check? (Y/N) **/
  );

  %let check = %upcase( &check );

  ** Voter Precinct code **;
  
  &outvar = put( 1 * substr(&invar,10,3), z3. );
  &outvar = upcase(&outvar);

  label
    &outvar = "Voting Precinct (2012)";
  
  %if &check = Y %then %do;
  
    %** Check that new values are valid **;
    
    if put( &outvar, $vote12v. ) = '' then do;
      %warn_put( macro=Octo_VoterPre2012, msg="Invalid 2012 Voting Precinct ID: " _n_= &invar= &outvar= )
    end;
    
  %end;
    
%mend Octo_VoterPre2012;


