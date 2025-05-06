/************************************************************************
  Program:  Block20_ANC23.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Rob Pitingolo
  Created:  05/01/2025
  Version:  SAS 9.4
  Environment:  Windows 11
  
  Description:  Create Census 2020 block to ANC (2023) 
  correspondence file.

  Adds correspondence format $bk2an3f. to local General library.

  Modifications: 
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_ANC23 
  (label="Census 2020 blocks (GeoBlk2020) to Advisory Neighborhood Commissions (Anc2023) correspondence file");

  set Cen2020m.Block20_ANC23;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBlk2020 = Geo2020 || Block;
  GeoBg2020 = substr(GeoBlk2020,1,12);
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  if put( GeoBlk2020, $blk20v. ) = '' then do;
    %warn_put( msg="Invalid 2020 block ID: " _n_= GeoBlk2020= Tract= BlkGrp= Block= )
  end;

  ** ANC 2023 var **;

  %Octo_Anc2023( invar=ANC_ID, check=y )
  
  label 
    ANC_ID = "OCTO ANC ID"
    NAME_1 = "OCTO ANC name"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2020 GeoBg2020 Geo2020 Anc2023 Tract BlkGrp Block ANC_ID NAME_1;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_ANC23,
  by=GeoBlk2020,
  id=Anc2023
)

proc sort data=Block20_ANC23 nodupkey;
  by GeoBlk2020;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2an3f,
  Data=Block20_ANC23,
  Value=GeoBlk2020,
  Label=Anc2023,
  OtherLabel="",
  Desc="Block 2020 to ANC 2023 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block20_ANC23,
    out=Block20_ANC23,
    outlib=general,
    label="Census 2020 blocks (GeoBlk2020) to Advisory Neighborhood Commissions (Anc2023) correspondence file",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
