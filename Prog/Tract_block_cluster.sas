/**************************************************************************
 Program:  Tract_block_cluster.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/20/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts and clusters,
 blocks and clusters.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

filename xin dde "excel|D:\DCData\Libraries\General\Doc\[clus_trct_bg2.xls]Sheet1!r2c1:r191c3" lrecl=256;

data tract block;

  infile xin;
  
  length cluster $ 2 geo2000 $ 11 bgrp $ 2;
  
  input cluster geo2000 bgrp;
  
  if bgrp = "99" then output tract;
  else output block;

run;

/*
proc catalog catalog=General.formats;
  delete tr_bgrp.formatc tr_clus.formatc;
quit;
*/

%Data_to_format( 
  FmtLib=General,
  FmtName=$trct_cl,
  Data=tract,
  Value=geo2000, 
  Label=cluster,
  OtherLabel="  ",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

%Data_to_format( 
  FmtLib=General,
  FmtName=$bgrp_cl,
  Data=block,
  Value=geo2000 || substr( bgrp, 2, 1 ), 
  Label=cluster,
  OtherLabel="  ",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

