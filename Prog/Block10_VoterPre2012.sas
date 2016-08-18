/************************************************************************
  Program:  Block10_VoterPre2012.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  12/05/12
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2010 block to Voting Precinct (2012) 
  correspondence file.

  Adds correspondence format $bk1vpaf. to local General library.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

libname Cen2010m "&_dcdata_path\General\Maps\Census 2010";

*options obs=50;

data General.Block10_VoterPre2012 
  (label="Census 2010 blocks (GeoBlk2010) to Voting Precincts (VoterPre2012) correspondence file");
  length name $19 voterpre2012 $3;

  set Cen2010m.Block10_VoterPre2012;
  
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

  ** VotingPre2012 var **;
  %Octo_VoterPre2012( check=y )
	
  name ='Voting ' || name;
  
  label 
    VoterPre2012 = "OCTO Voting Precinct ID"
    NAME = "OCTO Voting Precinct name"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 VoterPre2012 Tract BlkGrp Block NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_VoterPre2012,
  by=GeoBlk2010,
  id=VoterPre2012
)

proc sort data=General.Block10_VoterPre2012 nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_VoterPre2012, stats=, freqvars=VoterPre2012  )

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1vpaf,
  Data=General.Block10_VoterPre2012,
  Value=GeoBlk2010,
  Label=VoterPre2012,
  OtherLabel="",
  Desc="Block 2010 to Voting Precinct 2012 correspondence",
  Print=N,
  Contents=Y
  )
