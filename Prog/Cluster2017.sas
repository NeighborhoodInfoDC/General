/**************************************************************************
 Program:  Cluster2017.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  12/05/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  DC Neighborhood Clusters names data set and formats.

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data cluster2017 (label="List of DC Neighborhood Cluster (2017)"
);

  input cluster2017 $2. cluster2017_name & $99.;

  label 
    cluster2017 = 'Neighborhood Cluster (2017)'
    cluster2017_name = 'Neighborhood Cluster (2017) Name';

datalines;
1 National Mall, Potomac River
2 Brookland, Brentwood, Langdon
3 Takoma, Brightwood, Manor Park
4 Georgetown, Burleith/Hillandale
5 River Terrace, Benning, Greenway, Dupont Park
6 Near Southeast, Navy Yard
7 Woodland/Fort Stanton, Garfield Heights, Knox Hill
8 Douglas, Shipley Terrace
9 Congress Heights, Bellevue, Washington Highlands
10 Arboretum, Anacostia River
11 Joint Base Anacostia-Bolling
12 Saint Elizabeths
13 Observatory Circle
14 Rock Creek Park
15 Walter Reed
16 Capitol Hill, Lincoln Park
17 Cleveland Park, Woodley Park, Massachusetts Avenue Heights, Woodland-Normanstone Terrace
18 Cathedral Heights, McLean Gardens, Glover Park
19 Woodridge, Fort Lincoln, Gateway
20 Columbia Heights, Mt. Pleasant, Pleasant Plains, Park View
21 Edgewood, Bloomingdale, Truxton Circle, Eckington
22 Kalorama Heights, Adams Morgan, Lanier Heights
23 Union Station, Stanton Park, Kingman Park
24 Twining, Fairlawn, Randle Highlands, Penn Branch, Fort Davis Park, Fort Dupont
25 Sheridan, Barry Farm, Buena Vista
26 Fairfax Village, Naylor Gardens, Hillcrest, Summit Park
27 Historic Anacostia
28 Hawthorne, Barnaby Woods, Chevy Chase
29 Colonial Village, Shepherd Park, North Portal Estates
30 Lamont Riggs, Queens Chapel, Fort Totten, Pleasant Hill
31 Friendship Heights, American University Park, Tenleytown
32 Brightwood Park, Crestwood, Petworth
33 North Cleveland Park, Forest Hills, Van Ness
34 North Michigan Park, Michigan Park, University Heights
35 Spring Valley, Palisades, Wesley Heights, Foxhall Crescent, Foxhall Village, Georgetown Reservoir
36 Capitol View, Marshall Heights, Benning Heights
37 Southwest Employment Area, Southwest/Waterfront, Fort McNair, Buzzard Point
38 Howard University, Le Droit Park, Cardozo/Shaw
39 Dupont Circle, Connecticut Avenue/K Street
40 Ivy City, Arboretum, Trinidad, Carver Langston
41 Eastland Gardens, Kenilworth
42Shaw, Logan Circle
43 Deanwood, Burrville, Grant Park, Lincoln Heights, Fairmont Heights
44 Mayfair, Hillbrook, Mahaning Heights
45 West End, Foggy Bottom, GWU
46 Downtown, Chinatown, Penn Quarters, Mount Vernon Square, North Capitol Street
;
  
run;

**sort procedure changed the right order?**;
proc sort data=cluster2017;
  by cluster2017;
run;


** Create formats **;

** $cluster2017:  NeiName **;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus17a,
  Data=Cluster2017,
  Value=Cluster2017,
  Label=cluster2017_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $clus17v:  
** Validation format - returns Cluster2017 number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus17v
,
  Data=Cluster2017,
  Value=Cluster2017,
  Label=Cluster2017,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=general.formats entrytype=formatc;
  modify clus17a (desc="Neighborhood Cluster (2017), Area Names");
  modify clus17v (desc="Neighborhood Cluster  (2017), validation");
  contents;
  quit;

** Add $clus17a format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify cluster2017;
    format cluster2017 $clus17a.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=cluster2017,
  out=cluster2017,
  outlib=General,
  label="List of DC Neighborhood Clusters (2017)",
  sortby=cluster2017,
  restrictions=None,
  revisions=New File.,
  printobs=5,
  freqvars=
  );


/* End of Program */

