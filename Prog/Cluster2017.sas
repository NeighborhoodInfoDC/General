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
01 Kalorama Heights, Adams Morgan, Lanier Heights
02 Columbia Heights, Mt. Pleasant, Pleasant Plains, Park View
03 Howard University, Le Droit Park, Cardozo/Shaw
04 Georgetown, Burleith/Hillandale
05 West End, Foggy Bottom, GWU
06 Dupont Circle, Connecticut Avenue/K Street
07 Shaw, Logan Circle
08 Downtown, Chinatown, Penn Quarters, Mount Vernon Square, North Capitol Street
09 Southwest Employment Area, Southwest/Waterfront, Fort McNair, Buzzard Point
10 Hawthorne, Barnaby Woods, Chevy Chase
11 Friendship Heights, American University Park, Tenleytown
12 North Cleveland Park, Forest Hills, Van Ness
13 Spring Valley, Palisades, Wesley Heights, Foxhall Crescent, Foxhall Village, Georgetown Reservoir
14 Cathedral Heights, McLean Gardens, Glover Park
15 Cleveland Park, Woodley Park, Massachusetts Avenue Heights, Woodland-Normanstone Terrace
16 Colonial Village, Shepherd Park, North Portal Estates
17 Takoma, Brightwood, Manor Park
18 Brightwood Park, Crestwood, Petworth
19 Lamont Riggs, Queens Chapel, Fort Totten, Pleasant Hill
20 North Michigan Park, Michigan Park, University Heights
21 Edgewood, Bloomingdale, Truxton Circle, Eckington
22 Brookland, Brentwood, Langdon
23 Ivy City, Arboretum, Trinidad, Carver Langston
24 Woodridge, Fort Lincoln, Gateway
25 Union Station, Stanton Park, Kingman Park
26 Capitol Hill, Lincoln Park
27 Near Southeast, Navy Yard
28 Historic Anacostia
29 Eastland Gardens, Kenilworth
30 Mayfair, Hillbrook, Mahaning Heights
31 Deanwood, Burrville, Grant Park, Lincoln Heights, Fairmont Heights
32 River Terrace, Benning, Greenway, Dupont Park
33 Capitol View, Marshall Heights, Benning Heights
34 Twining, Fairlawn, Randle Highlands, Penn Branch, Fort Davis Park, Fort Dupont
35 Fairfax Village, Naylor Gardens, Hillcrest, Summit Park
36 Woodland/Fort Stanton, Garfield Heights, Knox Hill
37 Sheridan, Barry Farm, Buena Vista
38 Douglas, Shipley Terrace
39 Congress Heights, Bellevue, Washington Highlands
40 Walter Reed
41 Rock Creek Park
42 Observatory Circle
43 Saint Elizabeths
44 Joint Base Anacostia-Bolling
45 National Mall, Potomac River
46 Arboretum, Anacostia River
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
  revisions=Corrected cluster 2017 names.
  );

%file_info( data=General.cluster2017, printobs=5, stats= )


/* End of Program */

