/************************************************************************
  Program:  Block10_regcd.sas
  Library:  General
  Project:  Regional Racial Equity
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2010 block to Regional council districts
  correspondence file.

  Adds correspondence format $bk1regcd. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_regcd 
  (label="Census 2010 blocks (GeoBlk2010) to Regional council district (councildist) correspondence file");

  set Cen2010m.Block10_regcd;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  GeoBlk2010 = Geoid10;
  GeoBg2010 = GeoBlk2010; 
  Geo2010 = GeoBlk2010;
  
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
	GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** Regional Council District var **;

  %Regcd( check=y )
  
  label 
    regcd = "Regional Council District ID"
    Geoid10 = "Full census block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 regcd councildist Geoid10;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_regcd,
  by=GeoBlk2010,
  id=councildist
)

proc sort data=General.Block10_regcd nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_regcd, stats=, freqvars=councildist  )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1regcd,
  Data=General.Block10_regcd,
  Value=GeoBlk2010,
  Label=councildist,
  OtherLabel="",
  Desc="Block 2010 to Regional Council District correspondence",
  Print=N,
  Contents=Y
  )

