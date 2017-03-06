/************************************************************************
  Program:  Block10_bpk.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  02/16/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2010 block to Bridge Park area
  correspondence file.

  Adds correspondence format $bk1bpk. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_bpk 
  (label="Census 2010 blocks (GeoBlk2010) to Bridge Park area (bridgepk) correspondence file");

  set Cen2010m.Block10_bpk;
  
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

  ** Bridgepk var **;

  %Bridgepk( check=y )
  
  label 
    bridgepkID = "Bridge Park ID"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 bridgepkID bridgepk Tract BlkGrp Block;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_bpk,
  by=GeoBlk2010,
  id=bridgepk
)

proc sort data=General.Block10_bpk nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_bpk, stats=, freqvars=bridgepk  )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1bpk,
  Data=General.Block10_bpk,
  Value=GeoBlk2010,
  Label=bridgepk,
  OtherLabel="",
  Desc="Block 2010 to Bridge Park area correspondence",
  Print=N,
  Contents=Y
  )

