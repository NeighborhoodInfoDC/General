/**************************************************************************
 Program:  Block20_stantoncommons.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/14/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
Stanton Commons (stantoncommons) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_stantoncommons
  (label="Census 2020 blocks (GeoBlk2020) to Stanton Commons (stantoncommons) correspondence file");

  set Cen2020m.Block20_stantoncommons;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = substr(geoid,10,11);
  GeoBg2020 = substr(geoid,10,12);
  GeoBlk2020 = substr(geoid,10,15);
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** Stantoncommons code **;
  %Octo_stantoncommons(invar=_stanc);

  NAME = _stancname;
  
  label 
    Gis_id = "OCTO stantoncommons ID"
    NAME = "stantoncommons code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 stantoncommons Tract BlkGrp Block Gis_id ;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_stantoncommons,
  by=GeoBlk2020,
  id=stantoncommons
)

proc sort data=Block20_stantoncommons nodupkey;
  by GeoBlk2020;
run;


** Create correspondence format **;

%Data_to_format( 
  FmtLib=General,
  FmtName=$bk2stanc,
  Data=Block20_stantoncommons,
  Value=GeoBlk2020,
  Label=StantonCommons,
  OtherLabel="",
  Desc="Block 2020 to Stanton Commons corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=block20_stantoncommons,
    out=block20_stantoncommons,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to Stanton Commons (stantoncommons) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
