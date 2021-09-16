/**************************************************************************
 Program:  Block20_ward02.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/14/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Wards (Ward2002) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Ward02 
  (label="Census 2020 blocks (GeoBlk2020) to Wards (Ward2002) correspondence file");

  set Cen2020m.Block20_ward02;

  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** Ward code **;
  
  %Octo_ward2002(invar=ward_id)
  
  label 
    Gis_id = "OCTO Ward ID"
    NAME = "Ward code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove conflicting duplicate obs. **;

  ***if GeoBlk2020 = "110010068041004" and Ward2002 ~= "7" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Ward2002 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_Ward02,
  by=GeoBlk2020,
  id=Ward2002
)

proc sort data=Block20_Ward02 nodupkey;
  by GeoBlk2020;
run;


** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2wd2f,
  Data=Block20_Ward02,
  Value=GeoBlk2020,
  Label=Ward2002,
  OtherLabel="",
  Desc="Block 2020 to Ward 2002 correspondence",
  Print=N,
  Contents=Y
  )

  %Finalize_data_set(
    data=Block20_Ward02,
    out=Block20_Ward02,
    outlib=general,
    label="Block 2020 to Ward 2002 correspondence",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
