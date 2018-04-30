/**************************************************************************
 Program:  Block10_stantoncommons.sas
 Library:  General
 Project:  Stanton Commons
 Author:   Yipeng Su
 Created:  3/15/18
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
Stanton Commons (stantoncommons) correspondence file.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data Block10_stantoncommons
  (label="Census 2010 blocks (GeoBlk2010) to Stanton Commons (stantoncommons) correspondence file");

  set Cen2010m.Block10_stantoncommons;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** Stantoncommons code **;
  %Octo_stantoncommons()

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
  
  keep GeoBlk2010 GeoBg2010 Geo2010 stantoncommons Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block10_stantoncommons,
  by=GeoBlk2010,
  id=stantoncommons
)

proc sort data=Block10_stantoncommons nodupkey;
  by GeoBlk2010;
run;


** Create correspondence format **;

%Data_to_format( 
  FmtLib=General,
  FmtName=$bk1stanc,
  Data=Block10_stantoncommons,
  Value=GeoBlk2010,
  Label=StantonCommons,
  OtherLabel="",
  Desc="Block 2010 to Stanton Commons corresp",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=block10_stantoncommons,
    out=block10_stantoncommons,
    outlib=general,
    label="Census 2010 blocks (GeoBlk2010) to Stanton Commons (stantoncommons) correspondence file",
    sortby=GeoBlk2010,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
