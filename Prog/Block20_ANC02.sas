/**************************************************************************
 Program:  Block20_ANC02.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Elizabeth Burton
 Created:  09/15/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2030 blocks (GeoBlk2030) to 
 Advisory Neighborhood Commissions (ANC2002) correspondence file.

 Adds correspondence format $bk2an2f. to local General library.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_ANC02 
  (label="Census 2020 blocks (GeoBlk2020) to Advisory Neighborhood Commissions (ANC2002) correspondence file");

  set Cen2020m.block20_anc02;

  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = substr(geoid,10,11);
  GeoBg2020 = substr(geoid,10,12);
  GeoBlk2020 = substr(geoid,10,15);
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  ** ANC code **;
  
  %Octo_anc2002(invar=anc_id);

  label 
    Gis_id = "OCTO ANC ID"
    anc_id = "ANC code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format Gis_id Name Tract BlkGrp Block ;
  informat _all_ ;
  
  keep anc2002 Tract BlkGrp Block anc_id geoblk2020 GeoBg2020 Geo2020 ;
  
run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_ANC02,
  by=GeoBlk2020,
  id=anc2002
)

proc sort data=Block20_ANC02 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2an2f,
  Data=Block20_ANC02,
  Value=GeoBlk2020,
  Label=Anc2002,
  OtherLabel="",
  Desc="Block 2020 to ANC 2002 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_ANC02,
    out=Block20_ANC02,
    outlib=general,
    label="Block 2020 to ANC 2002 correspondence",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

