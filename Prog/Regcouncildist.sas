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
CA01 Calvert County, 1st District
CA02 Calvert County, 2nd District
CA03 Calvert County, 3rd District
CH99 Charles County
FR99 Frederick County
MT01 Montgomery County, District 1
MT02 Montgomery County, District 2
MT03 Montgomery County, District 3
MT04 Montgomery County, District 4
MT05 Montgomery County, District 5
PG01 Prince George's County, District 1
PG02 Prince George's County, District 2
PG03 Prince George's County, District 3
PG04 Prince George's County, District 4
PG05 Prince George's County, District 5
PG06 Prince George's County, District 6
PG07 Prince George's County, District 7
PG08 Prince George's County, District 8
PG09 Prince George's County, District 9
AR00 Arlington County
CL99 Clarke County
CU99 Culpeper County
FF01 Fairfax County, Braddock District
FF02 Fairfax County, Hunter Mill District
FF03 Fairfax County, Dranesville District
FF04 Fairfax County, Lee District
FF05 Fairfax County, Mason District
FF06 Fairfax County, Mount Vernon District
FF07 Fairfax County, Providence District
FF08 Fairfax County, Springfield District
FF09 Fairfax County, Sully District
FQ01 Fauquier County, Center District
FQ02 Fauquier County, Cedar Run District
FQ03 Fauquier County, Lee District
FQ04 Fauquier County, Marshall District
FQ05 Fauquier County, Scott District
LD01 Loudoun County, Dulles District
LD02 Loudoun County, Algonkian District
LD03 Loudoun County, Blue Ridge District
LD04 Loudoun County, Catoctin District
LD05 Loudoun County, Leesburg District
LD06 Loudoun County, Broad Run District
LD07 Loudoun County, Sterling District
LD08 Loudoun County, Ashburn District
PW05 Prince William County, Brentsville District
PW10 Prince William County, Coles District
PW20 Prince William County, Gainesville District
PW27 Prince William County, Neabsco District
PW30 Prince William County, Occoquan District
PW15 Prince William County, Potomac District
PW35 Prince William County, Woodbridge District
RH99 Rappahannock County
SP01 Spotsylvania County, Battlefield District
SP02 Spotsylvania County, Berkeley District
SP03 Spotsylvania County, Chancellor District
SP04 Spotsylvania County, Courtland District
SP05 Spotsylvania County, Lee Hill District
SP06 Spotsylvania County, Livingston District
SP07 Spotsylvania County, Salem District
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
  label="List of Regional Council District Areas",
  sortby=councildist,
  restrictions=None,
  revisions=New File.
  );

%file_info( data=General.Regcouncildist, printobs=0, stats= )


/* End of Program */
