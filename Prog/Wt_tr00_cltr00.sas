/**************************************************************************
 Program:  Wt_tr00_cltr00.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/02/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create tract to neighborhood cluster (tract/block
 based def.) weighting file.
 
 Uses "D:\DCData\Libraries\General\Doc\clus_trct_bg2.xls" as source.

 Modifications:
  04-05-06  Updated to new file standards.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

filename in_file dde "Excel|D:\DCData\Libraries\General\Doc\[clus_trct_bg2.xls]Sheet1!R2C1:R191C6";

data General.Wt_tr00_cltr00
       (compress=no label="Weighting file, 2000 tracts to 2000 neighborhood clusters (tract-based)");

  length cluster_tr2000 bgrp $ 2 geo2000 $ 11;
  
  infile in_file;

  input
    cluster_tr2000
    geo2000
    bgrp
    popwt
    hh_wgt
    hu_wgt
  ;

  label 
    popwt = "Population weight" 
    cluster_tr2000 = "Neighborhood cluster (tract-based, 2000)"
    geo2000 = "Full census tract ID (2000): ssccctttttt";

  format cluster_tr2000 $clus00a.;

  keep cluster_tr2000 geo2000 popwt;

run;

%File_info( data=General.Wt_tr00_cltr00, printobs=1000 )

