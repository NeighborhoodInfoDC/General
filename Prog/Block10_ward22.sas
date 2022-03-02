/************************************************************************
  Program:  Block10_Ward22.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  02/18/22
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2010 block to Ward (2022) 
  correspondence file.

  Adds correspondence format $bk1wdbf. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data Block10_Ward22
  (label="Census 2010 blocks (GeoBlk2010) to Wards (Ward2022) correspondence file");

  set Cen2010m.Block10_ward22;
  
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

  ** Ward2022 var **;

  %Octo_Ward2022( check=y )
  
  label 
    Ward = "OCTO Ward ID"
    NAME = "OCTO Ward name"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Ward2022 Tract BlkGrp Block Ward NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block10_Ward22,
  by=GeoBlk2010,
  id=Ward2022
)

proc sort data=Block10_Ward22 nodupkey;
  by GeoBlk2010;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1wdbf,
  Data=Block10_Ward22,
  Value=GeoBlk2010,
  Label=Ward2022,
  OtherLabel="",
  Desc="Block 2010 to Ward 2022 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block10_Ward22,
    out=Block10_Ward22,
    outlib=general,
    label="Census 2010 blocks (GeoBlk2010) to Wards (Ward2022) correspondence file",
    sortby=GeoBlk2010,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )
