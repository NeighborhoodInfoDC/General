/************************************************************************
  Program:  Block10_ANC23.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Rob Pitingolo
  Created:  05/01/25
  Version:  SAS 9.4
  Environment:  Windows 11
  
  Description:  Create Census 2010 block to ANC (2023) 
  correspondence file.

  Adds correspondence format $bk1an3f. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data Block10_ANC23
  (label="Census 2010 blocks (GeoBlk2010) to Advisory Neighborhood Commissions (Anc2023) correspondence file");

  set Cen2010m.Block10_ANC23;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  if put( GeoBlk2010, $blk10v. ) = '' then do;
    %warn_put( msg="Invalid 2010 block ID: " _n_= GeoBlk2010= Tract= BlkGrp= Block= )
  end;

  ** ANC 2023 var **;

  %Octo_Anc2023( invar=ANC_ID, check=y )
  
  label 
    ANC_ID = "OCTO ANC ID"
    NAME = "OCTO ANC name"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Anc2023 Tract BlkGrp Block ANC_ID NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block10_ANC23,
  by=GeoBlk2010,
  id=Anc2023
)

proc sort data=Block10_ANC23 nodupkey;
  by GeoBlk2010;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1an3f,
  Data=Block10_ANC23,
  Value=GeoBlk2010,
  Label=Anc2023,
  OtherLabel="",
  Desc="Block 2010 to ANC 2023 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block10_ANC23,
    out=Block10_ANC23,
    outlib=general,
    label="Census 2010 blocks (GeoBlk2010) to Advisory Neighborhood Commissions (Anc2023) correspondence file",
    sortby=GeoBlk2010,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )
