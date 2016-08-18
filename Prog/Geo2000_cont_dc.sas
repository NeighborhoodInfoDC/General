/**************************************************************************
 Program:  Geo2000_cont_dc.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/09/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read tract contiguity file created by GeoDa and create
 SAS data set with pairs of neighboring tract IDs.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( OCTO )

** Get correspondence between OBJECTID and tract IDs **;

libname dbmsdbf dbdbf "D:\DCData\Libraries\OCTO\Maps\" ver=4 width=12 dec=2
  Tract00P=Tract00Ply;

data TractId;

  set dbmsdbf.Tract00P (keep=objectid Fedtractno);
  
  %Fedtractno_geo2000
  
run;

%Data_to_format(
  FmtLib=work,
  FmtName=objgeo,
  Data=TractId,
  Value=objectid,
  Label=geo2000,
  OtherLabel=" ",
  DefaultLen=11,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** Read contiguity (GAL) file and create SAS data set **;

filename inf  "D:\DCData\Libraries\OCTO\Maps\Tract00Ply_cont_queen.GAL" lrecl=256;

data General.Geo2000_cont_queen_dc 
      (keep=geo2000 geo2000_nbr
       label="Census tract (2000) contiguity file, 1st order, queen, DC");

  infile inf;
  
  retain numobs 0;
  
  length 
    shapefile keyvariable $ 40 
    geo2000 geo2000_nbr $ 11;
  
  if _n_ = 1 then do;
    input x numobs shapefile keyvariable;
  end;

  input ref_tr nbrcount;
  
  geo2000 = put( ref_tr, objgeo. );
  
  do i = 1 to nbrcount;
    input nbr_tr @;
    geo2000_nbr = put( nbr_tr, objgeo. );
    output;
  end;
  
  input;
  
  put numobs= ;
  
  numobs = numobs - 1;
  
  label 
    geo2000 = "Reference tract, full census tract ID (2000): ssccctttttt"
    geo2000_nbr = "Neighboring tract, full census tract ID (2000): ssccctttttt";

run;

proc sort data=General.Geo2000_cont_queen_dc;
  by geo2000 geo2000_nbr;

%File_info( data=General.Geo2000_cont_queen_dc, printobs=0, stats= )

proc print;
  by geo2000;
  id geo2000;

run;
