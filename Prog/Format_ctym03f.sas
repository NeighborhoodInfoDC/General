/**************************************************************************
 Program:  Format_ctym03f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/23/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create format to convert county (UCOUNTY) to 
 2008 metro code (METRO03) for Washington, DC Metro.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

filename inf "D:\DCData\Libraries\General\Raw\03mfips.txt";

data d03mfips (label="Metro area definitions, June 6, 2003");

  infile inf firstobs=16 obs=3721 pad;
  
  length name03 $ 80;

  input
    metro03 $ 1-5   
    statecd $ 8-9
    councd $ 10-12
    name03 $ 14-88
    ;
    
  ** Washington DC Metro Only **;
    
  if metro03 = "47900";
  
  ** Fix zero-padding problem on state code **;
  
  if statecd ~= "" then statecd = put( 1 * statecd, z2.);

  label
    metro03 = "Five-digit metropolitan or micropolitan statistical area code (6/6/2003 definition)"
    statecd = "FIPS state code (blank at MA level)"
    councd = "FIPS county code (blank at MA level)"
    name03 = "Area title and county name";

  %ucounty( ucounty, Unique FIPS County ID:  ssccc, statecd, councd )
  
  ** Metro/Micro flag **;
  
  length metmic $ 5;
  retain metmic;
  
  if index( name03, "Metropolitan" ) then metmic = "METRO";
  else if index( name03, "Micropolitan" ) then metmic = "MICRO";

  ** Record type **;

  length rectype $ 1;

  if ucounty ~= "" then do;
    if metmic = "MICRO" then rectype = "4";
    else rectype = "3";
  end;
  else do;
    if metmic = "MICRO" then rectype = "2";
    else rectype = "1";
  end;
  
  label rectype = "Record type";
  
run;

proc contents data=d03mfips;

proc print data=d03mfips (obs=40);

proc format;
  value $rectype
    "1" = "Metropolitan Area title"
    "2" = "Micropolitan Area title"
    "3" = "County component of Metropolitan Area"
    "4" = "County component of Micropolitan Area";

proc freq data=d03mfips;
  tables rectype /missing;
  format rectype $rectype.;

proc sort data=d03mfips out=d03mfips;
  by rectype;

proc print data=d03mfips noobs;
  by rectype;
  id metro03;
  format rectype $rectype.;

run;

** Create ucounty -> metro lookup format ($ctym03f) **;

data ctrl2;

  set d03mfips end=last;
  where rectype in ( "3", "4" );
  
  retain fmtname "$ctym03f" type "c" hlo " ";

  output;
  
  if last then do;
    hlo = "o";
    metro03 = "";
    output;
  end;

  rename ucounty=start metro03=label;
  
run;

proc format library=general cntlin=ctrl2;

run;

proc catalog catalog=general.formats;
  modify ctym03f (desc="County to Wash Metro (2003)") / entrytype=formatc;
  contents;
run;

proc format library=general fmtlib;
  select $ctym03f;
run;

