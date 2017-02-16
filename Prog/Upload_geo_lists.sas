/**************************************************************************
 Program:  Upload_geo_lists.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/03/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload geographic list files to Alpha and register 
 metadata.

 Modifications:
  02/16/17 JD	Updated to run on L:\ Drive.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";
*%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General );

rsubmit;

/** Macro Upload_geo - Start Definition **/

%macro Upload_geo( data=, revisions=New file. );

  proc upload status=no
  data=General.&data 
  out=General.&data (compress=no);

  run;
  
  x "purge [DCData.General.data]&data..*";
  
  run;
  
  %Dc_update_meta_file(
    ds_lib=General,
    ds_name=&data,
    creator_process=&data..sas,
    restrictions=None,
    revisions=%str(&revisions)
  )
  
  run;

%mend Upload_geo;

/** End Macro Definition **/


** Execute macro for each file to be uploaded. **;
%Upload_geo( data=Bridgepk )


/**** PREVIOUSLY UPLOADED FILES ****
%Upload_geo( data=Psa2012, revisions=%str( Replaced with new file from OCTO. ) )
%Upload_geo( data=Anc2012 )
%Upload_geo( data=Psa2012 )
%Upload_geo( data=Ward2012 )
%Upload_geo( data=Geo1980 )
%Upload_geo( data=Geo1990 )
%Upload_geo( data=Geo1970 )
%Upload_geo( data=Ward2002 )
%Upload_geo( data=PSA2004 )
%Upload_geo( data=ANC2002 )
%Upload_geo( data=Geo2000 )
%Upload_geo( data=GeoBlk2000, revisions=Corrected cjrTractBl. )
%Upload_geo( data=Cluster2000, revisions=%str(Added NoMa to labels for cluster 25.) )
%Upload_geo( data=GeoBlk2000, revisions=%str(Add vars Geo2000, GeoBg2000, and City.) )
****/

run;

endrsubmit;

signoff;

