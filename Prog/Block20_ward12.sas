/************************************************************************
  Program:  Block20_Ward12.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/10/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2020 block to Ward (2012) 
  correspondence file.

  Adds correspondence format $bk2wdaf. to local General library.

  Modifications: Updated for 2020 redistricting data
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Ward12 
  (label="Census 2020 blocks (GeoBlk2020) to Wards (Ward2012) correspondence file");

  set Cen2020m.Block20_ward12;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = substr(geoid,10,11);
  GeoBg2020 = substr(geoid,10,12);
  GeoBlk2020 = substr(geoid,10,15);
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  if put( GeoBlk2020, $blk20v. ) = '' then do;
    %warn_put( msg="Invalid 2020 block ID: " _n_= GeoBlk2020= Tract= BlkGrp= Block= )
  end;

  ** Ward2012 var **;

  %Octo_Ward2012( invar=ward_id, check=y )
  
  label 
    Ward = "OCTO Ward ID"
    NAME = "OCTO Ward name"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Ward2012 Tract BlkGrp Block Ward NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_Ward12,
  by=GeoBlk2020,
  id=Ward2012
)

proc sort data=Block20_Ward12 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2wdaf,
  Data=Block20_Ward12,
  Value=GeoBlk2020,
  Label=Ward2012,
  OtherLabel="",
  Desc="Block 2020 to Ward 2012 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_Ward12,
    out=Block20_Ward12,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to Ward 2012 (Ward2012) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
