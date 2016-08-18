/**************************************************************************
 Program:  Format_bk0xxx.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create formats for converting blocks to other geos:
 $bk0ct0f. $bk0ca3f. $bk0cn3f. $bk0eor. $bk0city.
 
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

data Format;

  set General.GeoBlk2000;
  
  length geo2000 $ 11;
  geo2000 = geoblk2000;
  
  %Block00_to_cluster_tr00()
  %tr00_to_city()
  %tr00_to_eor()
  %tr00_to_cnb03()
  %tr00_to_cta03()

run;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0ct0f,
  Desc="Block 2000 to Nbr Clus (tract) 00 corres",
  Data=Format,
  Value=geoblk2000,
  Label=cluster_tr2000,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0ca3f,
  Desc="Block 2000 to Casey target area corresp",
  Data=Format,
  Value=geoblk2000,
  Label=casey_ta2003,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0cn3f,
  Desc="Block 2000 to Casey neighborhood corresp",
  Data=Format,
  Value=geoblk2000,
  Label=casey_nbr2003,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0eor,
  Desc="Block 2000 to EOR corresp",
  Data=Format,
  Value=geoblk2000,
  Label=eor,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=N
  )

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0city,
  Desc="Block 2000 to city corresp",
  Data=Format,
  Value=geoblk2000,
  Label=city,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=Y
  )

