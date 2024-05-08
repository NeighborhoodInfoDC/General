/**************************************************************************
 Macro:    Octo_Geo2020
 Library:  Octo
 Project:  Urban-Greater DC
 Author:   L. Hendey
 Created:  05/03/24
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Convert OCTO census track ID to Greater DC standard var Geo2020.
 
 Modifications:
  07/23/12 PAT Revised to conform with new OCTO 2010 block file vars.
  07/27/12 PAT Changed input var to conform with new version of 
               Block10Ply.shp created by R. Pitingolo.
               Restored INVAR= parameter.
**************************************************************************/

%macro Octo_Geo2020( 
  outvar=Geo2020, /** Output var name **/
  invar=geoid,     /** Input var **/
  check=n            /** Perform validity check? (Y/N) **/
);

  length Geo2020 $ 11;
  
  /**&outvar = '11001' || trim( left( Tract ) ) || trim( left( BlkGrp ) ) || left( Block );**/
  
  &outvar = left( &invar );
  
  label
    &outvar = "Full census tract ID (2020): ssccctttttt";

  %if %upcase( &check ) = Y %then %do;
    if put( &outvar, $geo20v. ) = '' then do;
      %warn_put( msg="Invalid 2020 Tract ID: " _n_= &outvar= &invar= )
    end;
  %end;

%mend Octo_Geo2020;

