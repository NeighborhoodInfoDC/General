************************************************************************
* Program:  Block10_ward12a.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  05/31/11
* Version:  SAS 9.2
* Environment:  Windows
* 
* Description:  Create Census 2010 block to Ward (2012, draft 5/26/11) file 
* from ArcGIS (DBF) source.
*
* NOTE:  Program requires DBMS/Engines
*
* Modifications:
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.Block10_ward12a 
  (label="Census 2010 blocks (GeoBlk2010) to Wards (Ward2012a) correspondence file");

  set General.Block10_ward12_draft_May26;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2010()

  ** Census block, block group, and tract IDs **;
  
  length Geo2010 $ 11 GeoBg2010 $ 12 GeoBlk2010 $ 15;
  
  Geo2010 = '11001' || Tract;
  GeoBg2010 = Geo2010 || BlkGrp;
  GeoBlk2010 = Geo2010 || Block;
  
  label
    GeoBlk2010 = 'Full census block ID (2010): sscccttttttbbbb'
    GeoBg2010 = 'Full census block group ID (2010): sscccttttttb'
    Geo2010 = 'Full census tract ID (2010): ssccctttttt';

  ** Ward2002 **;
  
  length Ward2002 $ 1;
  
  Ward2002 = put( GeoBlk2010, $bk1wd2f. ); 
  
  ** Create Ward2012a var **;
  
  length Ward2012a $ 1;
  
  if Ward2002 in ( '1', '3', '4' ) then do;
  
    ** Wards 1, 3, 4 unchanged **;
  
    Ward2012a = Ward2002;
    
  end;
  else if GeoBlk2010 in ( '110010046002017', '110010046002016', '110010046002018', '110010046002020' ) then do;
  
    ** Ward 5 blocks not in ArcMap file **;
    
    Ward2012a = '5';
    
  end;
/*  else if cjrTractBl in ( '9601 1999' ) then do;

    ** Correction **;
    
    Ward2012a = '7';
    
  end; */
  else do;
  
    Ward2012a = left( scan( Name, 2 ) );
    
  end;
  
  label 
    Ward2012a = 'Ward (2012, draft 5/26/11)'
    Ward2002 = 'Ward (2002)';

  label 
    Gis_id = "OCTO Ward ID"
    NAME = "Ward code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove conflicting duplicate obs. **;

  *****if GeoBlk2010 = "110010068041004" and Ward2002 ~= "7" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 Ward2002 Ward2012a Tract BlkGrp Block Gis_id NAME;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_ward12a,
  by=GeoBlk2010,
  id=Ward2002 Ward2012a
)

proc sort data=General.Block10_ward12a nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_ward12a, stats=, freqvars=Ward2002 Ward2012a  )

proc freq data=General.Block10_ward12a;
  tables Ward2002 * Ward2012a / missing list;
run;

** Display changes **;

proc sort data=General.Block10_ward12a out=Block10_ward12a;
  by Ward2002 Ward2012a;

proc print data=Block10_ward12a noobs;
  where Ward2002 ~= Ward2012a;
  by Ward2002 Ward2012a;
  var GeoBlk2010 Tract BlkGrp Block Name;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1wdaf,
  Data=General.Block10_ward12a,
  Value=GeoBlk2010,
  Label=Ward2012a,
  OtherLabel="",
  Desc="Block 2010 to Ward 2012a correspondence",
  Print=N,
  Contents=Y
  )

