/**************************************************************************
 Program:  Format_ctym15f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/09/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create format to convert county (UCOUNTY) to 
 2015 metro code (METRO15) for Washington, DC CBSA.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

filename inf "&_dcdata_r_path\General\Raw\15mfips.csv";

data d15mfips;

  infile inf dsd;
 
  length 
    Metro15 $ 5
    Statecd $ 2
    Councd $ 3
    ;

  input
    metro15
    statecd
    councd
    ;
    
  ** Washington DC Metro Only **;
    
  if metro15 = "47900";
  
  label
    metro15 = "Five-digit metropolitan or micropolitan statistical area code (2015 definition)"
    statecd = "FIPS state code (blank at MA level)"
    councd = "FIPS county code (blank at MA level)";

  %ucounty( ucounty, Unique FIPS County ID:  ssccc, statecd, councd )
  
run;

** Create ucounty -> metro lookup format ($ctym15f) **;

%Data_to_format(
  FmtLib=general,
  FmtName=$ctym15f,
  Desc="County to Wash Metro (2015)",
  Data=d15mfips,
  Value=ucounty,
  Label=metro15,
  OtherLabel="",
  DefaultLen=5,
  Print=Y,
  Contents=Y
  )

