/************************************************************************
  Program:  Block10_regcnt.sas
  Library:  General
  Project:  Regional Racial Equity
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2010 block to Regional county
  correspondence file.

  Adds correspondence format $bk1regcnt. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data Work.Block10_regcnt 
  (label="Census 2010 blocks (GeoBlk2010) to Regional county (county) correspondence file");

  set Cen2010m.Block10_regcnt;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  GeoBlk2010 = Geoid10;
  GeoBg2010 = GeoBlk2010; 
  Geo2010 = GeoBlk2010;
  
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
	GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';


  ** Regional County var **;

  %Regcnt( check=y )
  
  label 
    Geoid10 = "Full census block ID"
	geoid = "Full County ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 geoid county Geoid10;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Work.Block10_regcnt,
  by=GeoBlk2010,
  id=county
)

proc sort data=Work.Block10_regcnt nodupkey;
  by GeoBlk2010;

%File_info( data=Work.Block10_regcnt, stats=, freqvars=county  )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1regcnt,
  Data=Work.Block10_regcnt,
  Value=GeoBlk2010,
  Label=county,
  OtherLabel="",
  Desc="Block 2010 to Regional County correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set( 
  data=Block10_regcnt,
  out=Block10_regcnt,
  outlib=General,
  label="Census 2010 blocks (GeoBlk2010) to Regional county (county) correspondence file",
  sortby=GeoBlk2010,
  restrictions=None,
  revisions=New File.
  )
