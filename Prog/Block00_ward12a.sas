************************************************************************
* Program:  Block00_ward12a.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  05/31/11
* Version:  SAS 9.2
* Environment:  Windows
* 
* Description:  Create Census 2000 block to Ward (2012, draft 5/26/11) file 
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

data General.Block00_ward12a 
  (label="Census 2000 blocks (GeoBlk2000) to Wards (Ward2012a) correspondence file");

  set General.Block00_ward12_draft_May26;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";
    
  ** Ward2002 **;
  
  length Ward2002 $ 1;
  
  Ward2002 = put( GeoBlk2000, $bk0wd2f. ); 
  
  ** Create Ward2012a var **;
  
  length Ward2012a $ 1;
  
  if Ward2002 in ( '1', '3', '4' ) then do;
  
    ** Wards 1, 3, 4 unchanged **;
  
    Ward2012a = Ward2002;
    
  end;
  else if cjrTractBl in ( '4600 2006', '4600 2008', '4600 2009' ) then do;
  
    ** Ward 5 blocks not in ArcMap file **;
    
    Ward2012a = '5';
    
  end;
  else if cjrTractBl in ( '9601 1999' ) then do;

    ** Correction **;
    
    Ward2012a = '7';
    
  end;
  else do;
  
    Ward2012a = left( scan( Name, 2 ) );
    
  end;
  
  label 
    Ward2012a = 'Ward (2012, draft 5/26/11)'
    Ward2002 = 'Ward (2002)';

  label 
    CJRTRACTBL = "OCTO tract/block ID"
    Gis_id = "OCTO Ward ID"
    NAME = "Ward code"
    X = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    Y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove conflicting duplicate obs. **;

  *****if GEOBLK2000 = "110010068041004" and Ward2002 ~= "7" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  format x y 10.2;
  
  keep Geo2000 GeoBlk2000 Ward2002 Ward2012a CJRTRACTBL Gis_id NAME x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_ward12a,
  by=GeoBlk2000,
  id=Ward2002 Ward2012a
)

proc sort data=General.Block00_ward12a nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_ward12a, stats=, freqvars=Ward2002 Ward2012a  )

proc freq data=General.Block00_ward12a;
  tables Ward2002 * Ward2012a / missing list;
run;

** Display changes **;

proc sort data=General.Block00_ward12a out=Block00_ward12a;
  by Ward2002 Ward2012a;

proc print data=Block00_ward12a noobs;
  where Ward2002 ~= Ward2012a;
  by Ward2002 Ward2012a;
  var GeoBlk2000 CJRTRACTBL Name;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0wdaf,
  Data=General.Block00_ward12a,
  Value=GeoBlk2000,
  Label=Ward2012a,
  OtherLabel="",
  Desc="Block 2000 to Ward 2012a correspondence",
  Print=N,
  Contents=Y
  )

