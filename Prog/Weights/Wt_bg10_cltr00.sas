/************************************************************************
  Program:  Wt_bg10_cltr00.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  03/21/13
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create weighting file for converting 2010 block groups to
  2000 tract-based neighborhood clusters.

  Modifications: 07/29/2022 LH Update for SAS1
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Census )

%Calc_weights_from_blocks( 
  geo1 = GeoBg2010,
  geo2 = cluster_tr2000,
  out_ds = Wt_bg10_cltr00,
  block_corr_ds = General.Block10_cluster_tr00, 
  block = GeoBlk2010,
  block_pop_ds = Census.Census_pl_2010_dc (where=(sumlev='750')),
  block_pop_var = p0010001, 
  block_pop_year = 2010
)

