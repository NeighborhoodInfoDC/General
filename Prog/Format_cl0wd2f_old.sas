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
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data cl0wd2f (compress=no);

  infile datalines dsd;

  input ncluster nward;
  
  cluster = put( ncluster, z2.0 );
  ward = put( nward, z1.0 );
  
  drop ncluster nward;

datalines;
1,1
2,1
3,1
4,2
5,2
6,2
7,2
8,2
9,6
10,4
11,3
12,3
13,3
14,3
15,3
16,4
17,4
18,4
19,4
20,5
21,5
22,5
23,5
24,5
25,6
26,6
27,6
28,8
29,7
30,7
31,7
32,7
33,7
34,7
35,7
36,8
37,8
38,8
39,8
;

run;

%Data_to_format(
  FmtLib=General,
  FmtName=$cl0wd2f,
  Desc=Cluster 2000 to ward 2002 correspondence,
  Data=cl0wd2f,
  Value=cluster,
  Label=ward,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Contents=Y
  )


