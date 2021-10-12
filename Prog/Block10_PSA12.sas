/**************************************************************************
 Program:  Block10_Psa12.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/03/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Census 2010 blocks (GeoBlk2010) to 
 Police Service Areas (Psa2012) correspondence file.

 Adds correspondence format $bk1psaf. and $bk1pdaf. to local General library.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_Psa12 
  (label="Census 2010 blocks (GeoBlk2010) to Police Service Areas (Psa2012) correspondence file");

  set Cen2010m.Block10_PolSA12;

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

  ** PSA code **;
  
  %Octo_Psa2012( check=y )
  
  ** Police district code **;
  
  length PolDist2012 $ 2;
  
  PolDist2012 = put( poldist_id, 1. ) || 'D';
    
  label 
    PolDist2012 = "MPD Police District (2012)"
    poldist_id = "OCTO Police District ID"
    NAME = "OCTO PSA ID"
    PSA = "OCTO PSA code (number)"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Psa2012 PolDist2012 Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;

%Dup_check(
  data=General.Block10_Psa12,
  by=GeoBlk2010,
  id=Psa2012
)

proc sort data=General.Block10_Psa12 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_Psa12, stats=, freqvars=PolDist2012 Psa2012 )

run;

** Create correspondence formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1psaf,
  Data=General.Block10_Psa12,
  Value=GeoBlk2010,
  Label=Psa2012,
  OtherLabel="",
  Desc="Block 2010 to PSA 2012 correspondence",
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1pdaf,
  Data=General.Block10_Psa12,
  Value=GeoBlk2010,
  Label=PolDist2012,
  OtherLabel="",
  Desc="Block 2010 to PolDist 12 correspondence",
  Print=N,
  Contents=Y
  )

