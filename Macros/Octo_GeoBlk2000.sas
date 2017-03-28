/**************************************************************************
 Macro:    Octo_GeoBlk2000
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/16/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description: Convert OCTO census block ID to
 NeighborhoodInfo DC standard var GeoBlk2000.

 Modifications:
 07/04/12 PAT Added check= parameter to check block ID values.
**************************************************************************/

%macro Octo_GeoBlk2000( invar=CJRTRACTBL, outvar=GeoBlk2000, check=n );

  %let check = %upcase( &check );

  length &outvar $ 15;

  if &invar ~= "" then do;
    
    &outvar = "11001" || put( 1 * scan( &invar, 1 ), z6. ) || 
              put( 1 * scan( &invar, 2 ), z4. );
  
  end;

  label
    &outvar = "Full census block ID (2000): sscccttttttbbbb";

  %if &check = Y %then %do;
  
    if put( &outvar, $blk00v. ) = '' then do;
      %warn_put( msg="Invalid 2000 block ID: " _n_= &invar= &outvar= )
    end;
    
  %end;

%mend Octo_GeoBlk2000;



