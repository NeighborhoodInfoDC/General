/**************************************************************************
 Program:  Wt_tr00_hmt05.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/05/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create tract (2000) to housing market typology (2005) 
 weighting file.
 
 Uses General.Wt_tr00_cltr00 as input.
 
 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data General.Wt_tr00_hmt05
       (compress=no label="Weighting file, 2000 tracts to 2005 housing market typology");

  set General.Wt_tr00_cltr00;
  
  length hsng_mkt2005 $ 1;
  
  hsng_mkt2005 = put( cluster_tr2000, $clhmt5f. );

  label 
    hsng_mkt2005 = "Housing market typology (2005)"
  ;
  
  format hsng_mkt2005 $hmt05f.;

  *keep cluster_tr2000 geo2000 popwt;

run;

%File_info( data=General.Wt_tr00_hmt05, printobs=1000 )

