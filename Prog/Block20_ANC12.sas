/**************************************************************************
 Program:  Block20_Anc12.sas
 Library:  General
 Project:  Greater-Urban DC
 Author:   Elizabeth Burton
 Created:  09/15/2021
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Census 2020 blocks (GeoBlk2020) to 
 Advisory Neighborhood Commissions (anc2012) correspondence file.

 Adds correspondence format $bk2anaf. to local General library.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_Anc12 
  (label="Census 2020 blocks (GeoBlk2020) to Advisory Neighborhood Commissions (Anc2012) correspondence file");

  set Cen2020m.block20_Anc12;

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

  ** ANC code **;
  
  %Octo_anc2012(invar=anc_id, check=y )

  label 
    ANC_ID = "OCTO ANC code"
    Name = "OCTO ANC name"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format ANC_ID Name;
  informat _all_ ;
  
  keep anc2012 ANC_ID name GeoBlk2020 GeoBg2020 Geo2020 Tract BlkGrp Block;
  
run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_Anc12,
  by=GeoBlk2020,
  id=anc2012
)

proc sort data=Block20_Anc12 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2anaf,
  Data=Block20_Anc12,
  Value=GeoBlk2020,
  Label=anc2012,
  OtherLabel="",
  Desc="Block 2020 to ANC 2012 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_Anc12,
    out=Block20_Anc12,
    outlib=general,
    label="Block 2020 to ANC 2012 correspondence",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )

