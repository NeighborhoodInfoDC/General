/**************************************************************************
 Program:  BridgePk.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  02/14/17
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Bridge Park area names data set and formats.

 Modifications: 03/07/17 RP Fixed code that was returning errors when 
							batch sumbitting on L.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data Bridgepk (label="List of Bridge Park Areas");

  input bridgepk $1. BParea_name & $25.;

  label 
    bridgepk = 'Bridge Park Target Area (2017)'
    BParea_name = 'Bridge Park Target Area (2017) Name';

datalines;
1 West BP Impact Area
2 East BP Impact Area
3 Rest of DC, West of River
4 Rest of DC, East of River
;
  
run;


proc sort data=Bridgepk;
  by bridgepk;
run;

** Create formats **;

** $bpka:  Bridge Park Area Name **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bpka,
  Data=Bridgepk,
  Value=bridgepk,
  Label=BParea_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $bpkv:  
** Validation format - returns Bridge Park number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bpkv,
  Data=Bridgepk,
  Value=bridgepk,
  Label=bridgepk,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=general.formats entrytype=formatc;
  modify bpka (desc="Bridge Park Target Area (2017), Area Names");
  modify bpkv (desc="Bridge Park Target Area (2017), validation");
  contents;
  quit;

** Add $bpka format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify bridgepk;
    format bridgepk $bpka.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=Bridgepk,
  out=Bridgepk,
  outlib=General,
  label="List of Bridge Park Areas",
  sortby=bridgepk,
  restrictions=None,
  revisions=New File.
  );

%file_info( data=General.Bridgepk, printobs=0, stats= )


/* End of Program */
