/**************************************************************************
 Program:  Format_cl0wd2f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/01/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create cluster (2000) to ward (2002) correspondence
 format.

 Modifications:
  10/17/07 PT  New version based on land area from real property data.
               Old version saved as Format_cl0wd2f_old.sas
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( RealProp )

** Start submitting commands to remote server **;

rsubmit;

proc sql;
  create table Cluster_ward (compress=no) as
  select cluster_tr2000, ward2002, sum( landarea ) as sum_landarea from (
    select 
      coalesce( base.ssl, geo.ssl) as ssl, 
      geo.cluster_tr2000, geo.ward2002, 
      base.landarea, base.in_last_ownerpt 
    from RealProp.Parcel_base (where=(in_last_ownerpt and ui_proptype in ( '10', '11', '12', '13', '19' ))) as base 
      left join
      RealProp.Parcel_geo as geo
    on base.ssl = geo.ssl
    where geo.cluster_tr2000 not in ( '', '99' )
  )
  group by cluster_tr2000, ward2002
  order by cluster_tr2000, sum_landarea desc 
  ;

data Cluster_ward (compress=no);

  set Cluster_ward;
  by cluster_tr2000;
  
  if first.cluster_tr2000;
  
run;

*proc print data=Cluster_ward (obs=100);

%Data_to_format(
  FmtLib=General,
  FmtName=$cl0wd2f,
  Desc=Cluster 2000 to ward 2002 correspondence,
  Data=Cluster_ward,
  Value=cluster_tr2000,
  Label=ward2002,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Contents=Y
  )

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;

