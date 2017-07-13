/**************************************************************************
 Program:  Regcounty.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   J. Dev
 Created:  06/19/17
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Regional county area names data set and formats.

 Modifications: 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data Regcounty (label="List of Regional county Areas");

  input county $5. RCntarea_name & $22.;

  label 
    county = 'Regional counties (2017)'
    RCntarea_name = 'Regional counties (2017) Name';

datalines;
11001 District of Columbia
24033 Prince George's County
24031 Montgomery County
51013 Arlington County
51059 Fairfax County
51107 Loudoun County
51153 Prince William County
51510 Alexandria city
51600 Fairfax city
51610 Falls Church city
51683 Manassas city
51685 Manassas Park city
;
  
run;


proc sort data=Regcounty;
  by county;
run;

** Create formats **;

** $regcnta:  Regional County Name **;

%Data_to_format(
  FmtLib=General,
  FmtName=$regcnta,
  Data=Regcounty,
  Value=county,
  Label=RCntarea_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $regcntv:  
** Validation format - returns Regional County number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$regcntv,
  Data=Regcounty,
  Value=county,
  Label=county,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=general.formats entrytype=formatc;
  modify regcnta (desc="Regional counties (2017), Area Names");
  modify regctnv (desc="Regional counties (2017), validation");
  contents;
  quit;

** Add $regcnta format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify Regcounty;
    format county $regcnta.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=Regcounty,
  out=Regcounty,
  outlib=General,
  label="List of Regional County Areas",
  sortby=county,
  restrictions=None,
  revisions=New File.
  );

%file_info( data=General.Regcounty, printobs=0, stats= )


/* End of Program */
