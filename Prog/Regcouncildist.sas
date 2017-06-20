/**************************************************************************
 Program:  Regcouncildist.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Regional council District area names data set and formats.

 Modifications: 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data Regcouncildist (label="List of Regional Council District Areas");

  input councildist $4. RCDarea_name & $37.;

  label 
    councildist = 'Regional council districts (2017)'
    RCDarea_name = 'Regional council districts (2017) Name';

datalines;
DC01 DC, Ward 1
DC02 DC, Ward 2
DC03 DC, Ward 3
DC04 DC, Ward 4
DC05 DC, Ward 5
DC06 DC, Ward 6
DC07 DC, Ward 7
DC08 DC, Ward 8
FF01 Fairfax County, Braddock District
FF02 Fairfax County, Hunter Mill District
FF03 Fairfax County, Dranesville District
FF04 Fairfax County, Lee District
FF05 Fairfax County, Mason District
FF06 Fairfax County, Mount Vernon District
FF07 Fairfax County, Providence District
FF08 Fairfax County, Springfield District
FF09 Fairfax County, Sully District
MT01 Montgomery County, 1st District
MT02 Montgomery County, 2nd District
MT03 Montgomery County, 3rd District
MT04 Montgomery County, 4th District
MT05 Montgomery County, 5th District
PG01 Prince George's County, 1st District
PG02 Prince George's County, 2nd District
PG03 Prince George's County, 3rd District
PG04 Prince George's County, 4th District
PG05 Prince George's County, 5th District
PG06 Prince George's County, 6th District
PG07 Prince George's County, 7th District
PG08 Prince George's County, 8th District
PG09 Prince George's County, 9th District
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
