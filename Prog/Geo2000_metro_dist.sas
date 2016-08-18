/**************************************************************************
 Program:  Geo2000_metro_dist.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/02/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create data set with distance from census tract to
 nearest Metro station.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Octo )
%DCData_lib( General )

libname dbmsdbf dbdbf "D:\DCData\Libraries\OCTO\Maps\" ver=4 width=12 dec=2
  metro=Tract00Ply_MetroStn;

data General.Geo2000_metro_dist (label="Distance from census tract (2000) to nearest Metro station");

  set dbmsdbf.metro (keep=fedtractno distance);
  
  format _all_ ;
  informat _all_ ;
  
  %Fedtractno_geo2000
  
  label
    distance = 'Distance to nearest Metro station (meters, 0=station in tract)';
  
  drop fedtractno;

run;

proc sort data=General.Geo2000_metro_dist;
  by geo2000;

%File_info( data=General.Geo2000_metro_dist, printobs=200 )

