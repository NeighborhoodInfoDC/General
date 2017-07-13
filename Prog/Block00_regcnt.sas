/************************************************************************
  Program:  Block00_regcnt.sas
  Library:  General
  Project:  Regional Racial Equity
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2000 block to Regional Counties
  correspondence file.

  Adds correspondence format $bk0regcnt. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data Work.Block00_regcnt 
  (label="Census 2000 blocks (GeoBlk2000) to Regional county (county) correspondence file");

  set OCTO.Block00_regcnt;
  
  ** Census block, tract, and block group ID (needed for creating weight files)**;
  
  length GeoBg2000 $ 12 Geo2000 $ 11 GeoBlk2000 $15;
  
  GeoBlk2000 = STFID;
  Geo2000 = GeoBlk2000;
  GeoBg2000 = GeoBlk2000;

  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt"
	GeoBlk2000 = "Full census block ID (2000): sscccttttttbbbb";

  ** Regional County var **;

  %Regcnt( check=y )
  
  label 
    geoid = "Regional County ID"
	STFID = "Full census block ID (2000)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 geoid county STFID;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Work.Block00_regcnt,
  by=GeoBlk2000,
  id=county
)

proc sort data=Work.Block00_regcnt nodupkey;
  by GeoBlk2000;

%File_info( data=Work.Block00_regcnt, stats=, freqvars=county  )

/*
** Delete old formats **;

proc catalog catalog=General.Formats;
  delete bk0wdaf bk0wdbf / entrytype=formatc;
quit;
*/

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0regcnt,
  Data=Work.Block00_regcnt,
  Value=GeoBlk2000,
  Label=county,
  OtherLabel="",
  Desc="Block 2000 to Regional counties correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set( 
  data=Block00_regcnt,
  out=Block00_regcnt,
  outlib=General,
  label="Census 2000 blocks (GeoBlk2000) to Regional county (county) correspondence file",
  sortby=GeoBlk2000,
  restrictions=None,
  revisions=New File.
  )
