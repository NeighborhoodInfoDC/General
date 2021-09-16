/**************************************************************************
 Program:  Block20_Psa12.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/13/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Police Service Areas (Psa2012) correspondence file.

 Adds correspondence format $bk1psaf. and $bk1pdaf. to local General library.

 Modifications: Added 2020 redistricting data; Adds correspondence format $bk2psaf. and $bk2pdaf
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Psa12 
  (label="Census 2020 blocks (GeoBlk2020) to Police Service Areas (Psa2012) correspondence file");

  set Cen2020m.Block20_PSA12;

  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  if put( GeoBlk2020, $blk20v. ) = '' then do;
    %warn_put( msg="Invalid 2020 block ID: " _n_= GeoBlk2020= Tract= BlkGrp= Block= )
  end;

  ** PSA code **;
  
  %Octo_Psa2012(invar=name_1, check=y )
  
  ** Police district code **;
  
  length PolDist2012 $ 2;
  
  PolDist2012 = put( poldist_id, 1. ) || 'D';
    
  label 
    PolDist2012 = "MPD Police District (2012)"
    poldist_id = "OCTO Police District ID"
    NAME = "OCTO PSA ID"
    PSA = "OCTO PSA code (number)"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Psa2012 PolDist2012 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;

%Dup_check(
  data=Block20_Psa12,
  by=GeoBlk2020,
  id=Psa2012
)

proc sort data=Block20_Psa12 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1psaf,
  Data=Block20_Psa12,
  Value=GeoBlk2020,
  Label=Psa2012,
  OtherLabel="",
  Desc="Block 2020 to PSA 2012 correspondence",
  Print=N,
  Contents=N
  )

%Finalize_data_set(
    data=Block20_Psa12,
    out=Block20_Psa12,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to PSA 2012 (psa2012) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

