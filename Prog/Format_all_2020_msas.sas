/**************************************************************************
 Program:  Format_all_2020_msas.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/27/21
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  108
 
 Description:  Create formats for all 2020 metro areas.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

filename inf "&_dcdata_r_path\General\Raw\list1_2020.csv";

data Codes;

  infile inf dsd firstobs=4;
  
  length 
    Metro20 $ 5
    Metro_name $ 80
    Statecd $ 2
    Councd $ 3
    Ucounty $ 5
    Short_name $ 80
    skip1-skip8 $ 80
    ;
  
  input
    metro20
    skip1
    skip2
    Metro_name
    skip3
    skip4
    skip5
    skip6
    skip7
    statecd
    councd
    skip8
    ;
    
  if metro20 = "" then stop;
  
  Ucounty = trim( statecd ) || councd;
  
  Short_name = scan( Metro_name, 1, '-,/' );
    
  drop skip1-skip8;
 
run;

proc sort data=Codes out=Names (drop=statecd councd ucounty) nodupkey;
  by metro20;
run;

title2 '** List duplicate short names';

%Dup_check(
  data=Names,
  by=Short_name,
  id=metro20 Metro_name,
  out=_dup_check,
  listdups=Y,
  count=dup_check_count,
  quiet=N,
  debug=N
)

title2;


** Make formats **;

** Create ucounty -> metro lookup format ($ctym20f_all) **;

%Data_to_format(
  FmtLib=general,
  FmtName=$ctym20f_all,
  Desc="County Code (ssccc) to Metro Area Code - All Metros (2020)",
  Data=Codes,
  Value=ucounty,
  Label=metro20,
  OtherLabel="",
  DefaultLen=5,
  Print=Y,
  Contents=N
  )

** Create metro20 -> metro area full name ($msaname20_full) **;

%Data_to_format(
  FmtLib=general,
  FmtName=$msaname20_full,
  Desc="Metro Area Code to Full Name (2020)",
  Data=Names,
  Value=metro20,
  Label=Metro_name,
  OtherLabel="",
  Print=Y,
  Contents=N
  )

** Create metro20 -> metro area short name ($msaname20_short) **;

%Data_to_format(
  FmtLib=general,
  FmtName=$msaname20_short,
  Desc="Metro Area Code to Short Name (2020)",
  Data=Names,
  Value=metro20,
  Label=Short_name,
  OtherLabel="",
  Print=Y,
  Contents=Y
  )



