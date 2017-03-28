/**************************************************************************
 Macro:    Octo_ward2002
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO ward id to
 NeighborhoodInfo DC standard var Ward2002.

 Modifications:
**************************************************************************/

%macro Octo_ward2002( invar=ward_id, outvar=Ward2002 );

  length &outvar $ 1;

  if not &invar in ( "1", "2", "3", "4", "5", "6", "7", "8", " " ) then do;
    %warn_put( msg="Invalid ward ID: " _n_= &invar= )
  end;
  else do;
    &outvar = &invar;
  end;

  label
    &outvar = "Ward (2002)";

%mend Octo_ward2002;



