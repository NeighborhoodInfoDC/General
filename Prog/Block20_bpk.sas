/************************************************************************
  Program:  Block20_bpk.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/13/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2020 block to Bridge Park area
  correspondence file.

  Adds correspondence format $bk2bpk. to local General library.

  Modifications: Updated for 2020 redistricting data
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_bpk 
  (label="Census 2020 blocks (GeoBlk2020) to Bridge Park area (bridgepk) correspondence file");

  set Cen2020m.Block20_bpk;
  
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

  ** Bridgepk var **;

  %Bridgepk( invar=bridgepkID, check=y )
  
  label 
    bridgepkID = "Bridge Park ID"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 bridgepkID bridgepk Tract BlkGrp Block;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_bpk,
  by=GeoBlk2020,
  id=bridgepk
)

proc sort data=Block20_bpk nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2bpk,
  Data=Block20_bpk,
  Value=GeoBlk2020,
  Label=bridgepk,
  OtherLabel="",
  Desc="Block 2020 to Bridge Park area correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_bpk,
    out=Block20_bpk,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to Bridge Park area (2017)correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
