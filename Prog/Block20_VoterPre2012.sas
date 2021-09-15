/************************************************************************
  Program:  Block20_VoterPre2012.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   Elizabeth Burton
  Created:  09/14/2021
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2020 block to Voting Precinct (2012) 
  correspondence file.

  Adds correspondence format $bk2vpaf. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

libname Cen2020m "&_dcdata_path\General\Maps\Census 2020";

*options obs=50;

data Block20_VoterPre2012 
  (label="Census 2020 blocks (GeoBlk2020) to Voting Precincts (VoterPre2012) correspondence file");
  length name $19 voterpre2012 $3;

  set Cen2020m.Block20_VoterPre2012;
  
  ** Census block, block group, and tract IDs **;
  
  length Geo2020 $ 11 GeoBg2020 $ 12 GeoBlk2020 $ 15;
  
  Geo2020 = '11001' || Tract;
  GeoBg2020 = Geo2020 || BlkGrp;
  GeoBlk2020 = Geo2020 || Block;
  
  label
    GeoBlk2020 = 'Full census block ID (2020): sscccttttttbbbb'
    GeoBg2020 = 'Full census block group ID (2020): sscccttttttb'
    Geo2020 = 'Full census tract ID (2020): ssccctttttt';

  if put( GeoBlk2020, $blk20v. ) = '' then do;
    %warn_put( msg="Invalid 2020 block ID: " _n_= GeoBlk2020= Tract= BlkGrp= Block= )
  end;

  ** VotingPre2012 var **;
  %Octo_VoterPre2012(invar=name_1, check=y )
	
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
  
  keep GeoBlk2020 GeoBg2020 Geo2020 VoterPre2012 Tract BlkGrp Block NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block20_VoterPre2012,
  by=GeoBlk2020,
  id=VoterPre2012
)

proc sort data=Block20_VoterPre2012 nodupkey;
  by GeoBlk2020;
run;


** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk2vpaf,
  Data=Block20_VoterPre2012,
  Value=GeoBlk2020,
  Label=VoterPre2012,
  OtherLabel="",
  Desc="Block 2020 to Voting Precinct 2012 correspondence",
  Print=N,
  Contents=Y
  )

  %Finalize_data_set(
    data=Block20_VoterPre2012,
    out=Block20_VoterPre2012,
    outlib=general,
    label="Block 2020 to Voting Precinct 2012 correspondence",
    sortby=GeoBlk2020,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=5,
    freqvars=
  )
