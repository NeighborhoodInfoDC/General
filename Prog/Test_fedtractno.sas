/**************************************************************************
 Program:  Test_fedtractno.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/24/07
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

data Geo2000_fed;

  set General.Geo2000;
  
  %fedtractno

run;

data tract00ply;

  set Octo.tract00ply;
  
  %fedtractno_geo2000

run;

proc sort data=Geo2000_fed;
  by geo2000;

proc sort data=tract00ply;
  by geo2000;

data Geo2000_mrg;

  merge Geo2000_fed (in=inNcdb) tract00ply (in=inOcto);
  by geo2000;
  
  if not( inNcdb and inOcto ) then put geo2000= fedtractno= inNcdb= inOcto=;
  
run;

/*
proc print data=Geo2000_fed;
  var geo2000 fedtractno;
  
run;

