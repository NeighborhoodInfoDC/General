/**************************************************************************
 Program:  Regcouncildist.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Regional council District area names data set and formats.

 Modifications: 12/5/17 LH Added districts for Calvert, Fauquier, Loudoun,
			Prince William, Spotsylvania, and placeholders for others in 2015 MSA
		12/9/17 LH Updated Fauquier codes
		12/13/17 RP Shorted RCDarea_name to be less than 32 characters
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data Regcouncildist (label="List of Regional Council District Areas");

  input councildist $4. RCDarea_name & $50.;

  label 
    councildist = 'Regional council districts (2017)'
    RCDarea_name = 'Regional council districts (2017) Name';

	/*00 denotes no officials elected to represent sub-county -city areas.
	 99 denotes there are districts but we do not have the GIS layer*/

datalines;
DC01 DC, Ward 1
DC02 DC, Ward 2
DC03 DC, Ward 3
DC04 DC, Ward 4
DC05 DC, Ward 5
DC06 DC, Ward 6
DC07 DC, Ward 7
DC08 DC, Ward 8
CA01 Calvert, 1st District
CA02 Calvert, 2nd District
CA03 Calvert, 3rd District
CH99 Charles County
FD99 Frederick County
MT01 Montgomery, District 1
MT02 Montgomery, District 2
MT03 Montgomery, District 3
MT04 Montgomery, District 4
MT05 Montgomery, District 5
PG01 Prince George's, District 1
PG02 Prince George's, District 2
PG03 Prince George's, District 3
PG04 Prince George's, District 4
PG05 Prince George's, District 5
PG06 Prince George's, District 6
PG07 Prince George's, District 7
PG08 Prince George's, District 8
PG09 Prince George's, District 9
AR00 Arlington County
CL99 Clarke County
CU99 Culpeper County
FF01 Fairfax, Braddock District
FF02 Fairfax, Hunter Mill District
FF03 Fairfax, Dranesville District
FF04 Fairfax, Lee District
FF05 Fairfax, Mason District
FF06 Fairfax, Mount Vernon District
FF07 Fairfax, Providence District
FF08 Fairfax, Springfield District
FF09 Fairfax, Sully District
FQ02 Fauquier, Center District
FQ01 Fauquier, Cedar Run District
FQ03 Fauquier, Lee District
FQ04 Fauquier, Marshall District
FQ05 Fauquier, Scott District
LD01 Loudoun, Dulles District
LD02 Loudoun, Algonkian District
LD03 Loudoun, Blue Ridge District
LD04 Loudoun, Catoctin District
LD05 Loudoun, Leesburg District
LD06 Loudoun, Broad Run District
LD07 Loudoun, Sterling District
LD08 Loudoun, Ashburn District
PW05 Prince William, Brentsville District
PW10 Prince William, Coles District
PW20 Prince William, Gainesville District
PW27 Prince William, Neabsco District
PW30 Prince William, Occoquan District
PW15 Prince William, Potomac District
PW35 Prince William, Woodbridge District
RH99 Rappahannock County
SP01 Spotsylvania, Battlefield District
SP02 Spotsylvania, Berkeley District
SP03 Spotsylvania, Chancellor District
SP04 Spotsylvania, Courtland District
SP05 Spotsylvania, Lee Hill District
SP06 Spotsylvania, Livingston District
SP07 Spotsylvania, Salem District
ST99 Stafford County
WA99 Warren County
AL00 Alexandria
FA00 Fairfax City
FC00 Falls Church
FR99 Fredericksburg
MS00 Manassas
MP00 Manassas Park
JF99 Jefferson County
;
  
run;


proc sort data=Regcouncildist;
  by councildist;
run;

** Create formats **;

** $regcda:  Regional Council District Name **;

%Data_to_format(
  FmtLib=General,
  FmtName=$regcda,
  Data=Regcouncildist,
  Value=councildist,
  Label=RCDarea_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $regcdv:  
** Validation format - returns Regional Council District number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$regcdv,
  Data=Regcouncildist,
  Value=councildist,
  Label=councildist,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=general.formats entrytype=formatc;
  modify regcda (desc="Regional council districts (2017), Area Names");
  modify regcdv (desc="Regional council districts (2017), validation");
  contents;
  quit;

** Add $regcda format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify Regcouncildist;
    format councildist $regcda.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=Regcouncildist,
  out=Regcouncildist,
  outlib=General,
  label="List of Regional Council District Areas in the Washington DC Metro Area",
  sortby=councildist,
  restrictions=None,
  revisions=Updated Fauquier codes. ,
  stats=
  );

%file_info( data=General.Regcouncildist, printobs=0, stats= )


/* End of Program */
