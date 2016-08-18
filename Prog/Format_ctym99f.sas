/**************************************************************************
 Program:  Format_ctym99f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/23/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create format to convert county (UCOUNTY) to 
 1999 MSA/PMSA code (MSAPMA99) for Washington, DC Metro.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

** MSA/CMSA/PMSA **;

filename infm "D:\DCData\Libraries\General\Raw\99mfips.txt";

data d99mfips;

  infile infm firstobs=22 obs=2172 pad;

  length name99 $ 80;
  
  input
    msacma99 $ 1-4   
    pmsa99 $ 9-12  
    cmsa99 $ 17-18
    statecd $ 25-26
    councd $ 27-29
    cenout99 $ 33-33
    place98 $ 41-45
    name99 $ 49-88
    ;
    
  if msacma99 = "" then delete;

  label
    msacma99 = "Four-digit FIPS MSA/CMSA code (6/30/99 definition)"
    pmsa99 = "Four-digit FIPS PMSA code (6/30/99 definition)"
    cmsa99 = "Alternative two-digit FIPS CMSA code(6/30/99 definition)"
    statecd = "FIPS state code (blank at MA level)"
    councd = "FIPS county code (blank at MA level)"
    cenout99 = "Central/Outlying county or city/town flag (1 = Central, 2 = Outlying)"
    place98 = "FIPS entity code (blank at MA and county levels)"
    name99 = "Area title, county name, and town name";

  %ucounty( ucounty, Unique FIPS County ID:  ssccc, statecd, councd )

  if not( msacma99 ~= "" and cmsa99 ~= "" and pmsa99 = "" ) then do;
    %msapma( msapma99, Four-digit FIPS MSA/PMSA code (6/30/99 definition), msacma99, pmsa99 )
  end;


  ** Washington, DC PMSA only **;

  if msapma99 = '8840';

  %uplace( uplace98, Unique FIPS Place ID (1998):  ssppppp, statecd, place98 )

  length metro99 $ 4;
  
  if msapma99 ~= "" then metro99 = msapma99;
  else metro99 = msacma99;

  ** County part flag **;
  
  if index( name99, "(pt.)" ) > 0 then cntypt = "Y";
  else cntypt = "";
  
  label cntypt = "County part ('Y'=Yes)";
      
  length rectype $ 1;

  if place98 ~= "" then rectype = "6";
  else if ucounty ~= "" then rectype = "5";
  else if pmsa99 ~= "" then rectype = "3";
  else if cmsa99 ~= "" then rectype = "2";
  else rectype = "1";

  label rectype = "Record type";
  
  label metro99 = "Metro area (MSA/CMSA/PMSA/NECMA) code (1999 def.)";
  
run;

proc contents data=d99mfips;

proc print data=d99mfips (obs=50);

proc format;
  value $rectype
    "1" = "MSA title"
    "2" = "CMSA title"
    "3" = "PMSA title"
    "4" = "NECMA title"
    "5" = "County component of MSA/CMSA"
    "6" = "Place component of MSA/CMSA"
    "7" = "County compoment of NECMA";

proc freq data=d99mfips;
  tables rectype cntypt /missing;
  format rectype $rectype.;

proc sort data=d99mfips out=d99mfips;
  by rectype;

proc print data=d99mfips noobs;
  by rectype;
  id metro99;
  format rectype $rectype.;

run;

** Create ucounty -> MSA/PMSA/NECMA lookup format ($ctym99f) **;

data ctrl2;

  set d99mfips end=last;
  where ( rectype = "5" and statecd not in ( "09", "23", "25", "33", "44", "50" ) )
    or rectype = "7";
  
  retain fmtname "$ctym99f" type "c" hlo " ";
  
  if rectype = "5" then metro99 = msapma99;

  output;
  
  if last then do;
    hlo = "o";
    metro99 = "";
    output;
  end;

  rename ucounty=start metro99=label;
  
  keep rectype fmtname type hlo ucounty metro99 msapma99;
  
run;

*proc print data=ctrl2;

proc format library=general cntlin=ctrl2;

run;

** Display contents of format library, new formats **;

proc catalog catalog=general.formats;
  modify ctym99f (desc="County to Wash PMSA (1999)") / entrytype=formatc;
  contents;
run;

proc format library=general fmtlib;
  select $ctym99f;
run;


