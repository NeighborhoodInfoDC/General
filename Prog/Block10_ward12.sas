/************************************************************************
  Program:  Block10_Ward12.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  07/04/12
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2010 block to Ward (2012) 
  correspondence file.

  Adds correspondence format $bk1wdaf. to local General library.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_Ward12 
  (label="Census 2010 blocks (GeoBlk2010) to Wards (Ward2012) correspondence file");

  set Cen2010m.Block10_ward12;
  
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

  ** Ward2012 var **;

  %Octo_Ward2012( check=y )
  
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
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Ward2012 Tract BlkGrp Block Ward NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_Ward12,
  by=GeoBlk2010,
  id=Ward2012
)

proc sort data=General.Block10_Ward12 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_Ward12, stats=, freqvars=Ward2012  )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1wdaf,
  Data=General.Block10_Ward12,
  Value=GeoBlk2010,
  Label=Ward2012,
  OtherLabel="",
  Desc="Block 2010 to Ward 2012 correspondence",
  Print=N,
  Contents=Y
  )

