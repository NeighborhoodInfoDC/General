/************************************************************************
  Program:  Block00_regcd.sas
  Library:  General
  Project:  Regional Racial Equity
  Author:   J. Dev
  Created:  06/20/17
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2000 block to Regional Council District area
  correspondence file.

  Adds correspondence format $bk0regcd. to local General library.

  Modifications: 12/6/17 LH Corrected PG Districts and added others in MSA
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data Work.Block00_regcd 
  (label="Census 2000 blocks (GeoBlk2000) to Regional council district (councildist) correspondence file");

  set OCTO.Block00_regcd;
  
  
  ** Census block, tract, and block group ID (needed for creating weight files)**;
  
  length GeoBg2000 $ 12 Geo2000 $ 11 GeoBlk2000 $15;
  
  GeoBlk2000 = STFID;
  Geo2000 = GeoBlk2000;
  GeoBg2000 = GeoBlk2000;

  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt"
	GeoBlk2000 = "Full census block ID (2000): sscccttttttbbbb";

  ** Regional Council Districts var **;

  %Regcd( check=y )
  
  label 
    regcd = "Regional Council District ID"
	STFID = "Full census block ID (2000)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 regcd councildist STFID;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Work.Block00_regcd,
  by=GeoBlk2000,
  id=councildist
)

proc sort data=Work.Block00_regcd nodupkey;
  by GeoBlk2000;

%File_info( data=Work.Block00_regcd, stats=, freqvars=councildist  )

/*
** Delete old formats **;

proc catalog catalog=General.Formats;
  delete bk0wdaf bk0wdbf / entrytype=formatc;
quit;
*/

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0regcd,
  Data=Work.Block00_regcd,
  Value=GeoBlk2000,
  Label=councildist,
  OtherLabel="",
  Desc="Block 2000 to Regional council district correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set( 
  data=Block00_regcd,
  out=Block00_regcd,
  outlib=General,
  label="Census 2000 blocks (GeoBlk2000) to Regional council district (councildist) correspondence file",
  sortby=GeoBlk2000,
  restrictions=None,
  revisions=Corrected PG Districts and added others in MSA.,
  stats=
  )
