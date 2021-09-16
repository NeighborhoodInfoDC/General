/**************************************************************************
 Program:  Block20_tract00.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/14/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Census 2000 tract (Geo2000) correspondence file.
 
 Creates correspondence format $bk2tr0f.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_tract00 
  (label="Census 2020 blocks (GeoBlk2020) to Census 2000 tract (Geo2000) correspondence file");

  set Cen2020m.Block20_tract00;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** Census 2000 tract **;
  
  %Fedtractno_geo2000()
  
  label 
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
	Fedtractno = "Federal Tract No"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Geo2000 Fedtractno;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_tract00,
  by=GeoBlk2020,
  id=Geo2000
)

proc sort data=Block20_tract00 nodupkey;
  by GeoBlk2020;
run;


** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2tr0f,
  Data=Block20_tract00,
  Value=GeoBlk2020,
  Label=Geo2000,
  OtherLabel="",
  Desc="Block 2020 to Tract 2000 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_tract00,
    out=Block20_tract00,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to Tract 2000 correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )


