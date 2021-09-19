/**************************************************************************
 Program:  Format_ctym20f.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  9/19/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  104
 
 Description:  Create format to convert county (UCOUNTY) to 
 2020 metro code (METRO20) for Washington, DC CBSA.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

filename inf "&_dcdata_r_path\General\Raw\20mfips.csv";

data d20mfips;

  infile inf dsd;
 
  length 
    Metro20 $ 5
    Statecd $ 2
    Councd $ 3
    ;

  input
    metro20
    statecd
    councd
    ;
    
  ** Washington DC Metro Only **;
    
  if metro20 = "47900";
  
  label
    metro20 = "Five-digit metropolitan or micropolitan statistical area code (2020 definition)"
    statecd = "FIPS state code (blank at MA level)"
    councd = "FIPS county code (blank at MA level)";

  %ucounty( ucounty, Unique FIPS County ID:  ssccc, statecd, councd )
  
run;

proc print data=d20mfips;
run;

** Create ucounty -> metro lookup format ($ctym20f) **;

%Data_to_format(
  FmtLib=general,
  FmtName=$ctym20f,
  Desc="County to Wash Metro (2020)",
  Data=d20mfips,
  Value=ucounty,
  Label=metro20,
  OtherLabel="",
  DefaultLen=5,
  Print=Y,
  Contents=Y
  )

