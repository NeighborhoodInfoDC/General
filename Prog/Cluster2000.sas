/**************************************************************************
 Program:  Cluster2000.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/18/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Neighborhood cluster names data set and formats.

 Modifications:
  02/17/06 PAT  Added short names, $clus00s format.
  10/19/07 PAT  Changed short name for cl. 8 to 'Downtown/N. Capitol St.'
                Added NoMa to list of neighborhoods for cl. 25.
  08/06/08 PAT  Changed short name for cl. 23 to 'Ivy City/Trinidad'
                Changed short name for cl. 14 to 'Cathedral Hts./Glover Pk.'
  10/20/09 PAT  Removed use of DBMS engines (no longer supported in SAS 9)
                Added format 
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Octo )

** Maximum number of neighborhood names **;

%let MAX_NEIGHBORHOODS = 6;

** Create data set **;

data General.cluster2000 (label="List of DC neighborhood clusters (2000)");

  length cluster2000 $ 2 ward2002 $ 1 nbh_names $ 120 
    nbh_names_1 - nbh_names_&MAX_NEIGHBORHOODS $ 40
    temp nbh_names_sh $ 80;

  set Octo.Nbhclusply end=eof;
  
  format _all_ ;
  informat _all_ ;
  
  cluster2000 = put( input( substr( name, 9 ), 2. ), z2. );
  
  ** Wards **;

  ward2002 = put( cluster2000, $cl0wd2f. );
  
  label ward2002 = 'Ward (2002)';
  format ward2002 $ward02a.;
  
  ** Neighborhood names **;
  
  nbh_names = trim( left( compbl( nbh_names ) ) );
  
  ** Corrections **;
  
  nbh_names = tranwrd( nbh_names, 'Lamont Riggs', 'Lamond Riggs' );

  select ( cluster2000 );
    when ( '25' )
      nbh_names = 'NoMa, Union Station, Stanton Park, Kingman Park';
    otherwise
      /** No action **/ ;
  end;

  ** Separate individual neighborhood names **;
  
  array nbh_n{*} nbh_names_1 - nbh_names_&MAX_NEIGHBORHOODS;
  
  i = 1;
  temp = scan( nbh_names, i, ',' );
  
  do until ( temp = '' );
    nbh_n{i} = temp;
    i = i + 1;
    temp = scan( nbh_names, i, ',' );
  end;
  
  ** Create short list of neighborhood names for cluster **;
  
  if nbh_names_2 = '' then
    nbh_names_sh = nbh_names_1;
  else 
    nbh_names_sh = trim( nbh_names_1 ) || '/' || left( nbh_names_2 ); 
  
  nbh_names_sh = tranwrd( nbh_names_sh, 'American University', 'AU' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'University', 'Univ.' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'Heights', 'Hts.' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'North', 'N.' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'Avenue', 'Av.' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'Street', 'St.' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'Park', 'Pk.' );
  nbh_names_sh = tranwrd( nbh_names_sh, 'Connecticut', 'Conn.' );
  
  ** Manual corrections to short names **;
  
  select ( cluster2000 );
    when ( '04' )
      nbh_names_sh = 'Georgetown/Burleith';
    when ( '08' )
      nbh_names_sh = 'Downtown/N. Capitol St.';
    when ( '09' )
      nbh_names_sh = 'SW Employment Area/Waterfront';
    when ( '14' )
      nbh_names_sh = 'Cathedral Hts./Glover Pk.';
    when ( '23' )
      nbh_names_sh = 'Ivy City/Trinidad';
    when ( '25' )
      nbh_names_sh = 'NoMa/Union Station/Stanton Pk.';
    when ( '36' )
      nbh_names_sh = 'Woodland/Fort Stanton';
    otherwise
      /** No action **/ ;
  end;
  
  label 
    cluster2000 = 'Neighborhood cluster (2000)'
    name = 'Cluster label (Cluster xx)'
    nbh_names = 'Cluster neighborhood names'
    nbh_names_1 = 'Cluster neighborhood names, 1st neighborhood'
    nbh_names_2 = 'Cluster neighborhood names, 2nd neighborhood'
    nbh_names_3 = 'Cluster neighborhood names, 3rd neighborhood'
    nbh_names_4 = 'Cluster neighborhood names, 4th neighborhood'
    nbh_names_5 = 'Cluster neighborhood names, 5th neighborhood'
    nbh_names_6 = 'Cluster neighborhood names, 6th neighborhood'
    nbh_names_sh = 'Cluster neighborhood names, short'
    ;
  
  output;
  
  ** Add obs. for non-cluster areas **;
  
  if eof then do;
    cluster2000 = '99';
    ward2002 = put( cluster2000, $cl0wd2f. );
    nbh_names = 'Non-cluster area';
    name = 'Non-cluster area';
    nbh_names_sh = 'Non-cluster area';
    nbh_names_1 = 'Non-cluster area';
    do i = 2 to dim( nbh_n );
      nbh_n{i} = '';
    end;
    output;
  end;

  drop objectid gis_id web_url i temp;
  
  rename name=cluster_num;
  
run;

proc sort data=General.cluster2000;
  by cluster2000;

** Create formats **;

** $clus00a:  Cluster xx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus00a,
  Data=General.cluster2000,
  Value=cluster2000,
  Label=cluster_num,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $clus00f:  Cluster xx (neighborhoods) **;

data clus00f;
  set General.cluster2000;
  if cluster2000 ~= '99' then
    clabel = trim( cluster_num ) || " (" || trim( nbh_names ) || ")";
  else
    clabel = "Non-cluster area";
run;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus00f,
  Data=clus00f,
  Value=cluster2000,
  Label=clabel,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $clus00g:  xx (neighborhoods) **;

data clus00g;
  set General.cluster2000;
  if cluster2000 ~= '99' then
    clabel = trim( cluster2000 ) || " (" || trim( nbh_names ) || ")";
  else
    clabel = "Non-cluster area";
run;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus00g,
  Data=clus00g,
  Value=cluster2000,
  Label=clabel,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $clus00b:  Neighborhoods **;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus00b,
  Data=General.cluster2000,
  Value=cluster2000,
  Label=nbh_names,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $clus00s:  Neighborhoods (short) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus00s,
  Data=General.cluster2000,
  Value=cluster2000,
  Label=nbh_names_sh,
  OtherLabel=,
  DefaultLen=30,
  MaxLen=30,
  MinLen=.,
  Print=Y
  )

** $clus00v:  
** Validation format - returns cluster number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$clus00v,
  Data=General.cluster2000,
  Value=cluster2000,
  Label=cluster2000,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


proc catalog catalog=general.formats entrytype=formatc;
  modify clus00a (desc="Nbrhd clusters (2000), 'Cluster nn'");
  modify clus00f (desc="Nbrhd clusters (2000), 'Cluster nn (..)'");
  modify clus00g (desc="Nbrhd clusters (2000), 'nn (..)'");
  modify clus00b (desc="Nbrhd clusters (2000), nbrhd names only");
  modify clus00s (desc="Nbrhd clusters (2000), short nbrhd names");
  modify clus00v (desc="Nbrhd clusters (2000), validation");
  contents;
  quit;
  
** Add $clus00f format to data set **;

proc datasets library=General nolist memtype=(data);
  modify cluster2000;
    format cluster2000 $clus00f.;
quit;

%file_info( data=General.cluster2000, printobs=0, stats= )

proc print data=General.cluster2000;
  id cluster2000;
  var ward2002 nbh_names nbh_names_sh;

run;

