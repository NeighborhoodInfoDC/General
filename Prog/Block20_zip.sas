/**************************************************************************
 Program:  Block20_zip.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/14/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 ZIP codes (ZIP) correspondence file.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Zip 
  (label="Census 2020 blocks (GeoBlk2020) to ZIP codes correspondence file");

  set Cen2020m.block20_zip;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** ZIP code **;
  
  %Octo_zip(invar=zipcode);
  
  label 
    Gis_id = "OCTO ZIP code ID"
    zipcode = "ZIP code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Zip zipcode Tract BlkGrp Block Gis_id;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_Zip,
  by=GeoBlk2020,
  id=Zip
)

proc sort data=Block20_Zip nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2zipf,
  Data=Block20_Zip,
  Value=GeoBlk2020,
  Label=Zip,
  OtherLabel="",
  Desc="Block 2020 to ZIP code correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_Zip,
    out=Block20_Zip,
    outlib=general,
    label="Block 2020 to ZIP code correspondence",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
