/**************************************************************************
 Program:  Format_cl17wd12f.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  9/9/19
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  Create cluster (2017) to ward (2012) correspondence
 format.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RealProp )


proc sql;
  create table Cluster_ward (compress=no) as
  select cluster2017, ward2012, sum( landarea ) as sum_landarea from (
    select 
      coalesce( base.ssl, geo.ssl) as ssl, 
      geo.cluster2017, geo.ward2012, 
      base.landarea, base.in_last_ownerpt 
    from RealProp.Parcel_base (where=(in_last_ownerpt and ui_proptype in ( '10', '11', '12', '13', '19' ))) as base 
      left join
      RealProp.Parcel_geo as geo
    on base.ssl = geo.ssl
    where geo.cluster2017 not in ( '', '99' )
  )
  group by cluster2017, ward2012
  order by cluster2017, sum_landarea desc 
  ;

data Cluster_ward (compress=no);

  set Cluster_ward;
  by cluster2017;
  
  if first.cluster2017;
  
run;

proc print data=Cluster_ward ; run;

%Data_to_format(
  FmtLib=General,
  FmtName=$cl17wd12f,
  Desc=Cluster 2017 to ward 2012 correspondence,
  Data=Cluster_ward,
  Value=cluster2017,
  Label=ward2012,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Contents=Y
  );

/* End of program */
