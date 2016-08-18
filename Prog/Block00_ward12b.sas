************************************************************************
* Program:  Block00_ward12b.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  05/31/11
* Version:  SAS 9.2
* Environment:  Windows
* 
* Description:  Create Census 2000 block to Ward (2012, draft 6/8/11) file 
* from ArcGIS (DBF) source.
*
* NOTE:  Program requires DBMS/Engines
*
* Modifications:
   06/13/11 PAT  Corrected definitions of wards 1, 3, 4.
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.Block00_ward12b 
  (label="Census 2000 blocks (GeoBlk2000) to Wards (Ward2012b) correspondence file");

  set General.Block00_ward12_draft_Jun8;
  
  ** Census block and tract IDs **;
  
  %Octo_GeoBlk2000()

  length Geo2000 $ 11;
  
  Geo2000 = GeoBlk2000;
  
  label 
    GEO2000 = "Full census tract ID (2000): ssccctttttt";
    
  ** Ward2002 **;
  
  length Ward2002 $ 1;
  
  Ward2002 = put( GeoBlk2000, $bk0wd2f. ); 
  
  ** Create Ward2012b var **;
  
  length Ward2012b $ 1;
  
  /** Correction: tract 68.04, block 1010 (Congressional Cemetery) -> Ward 7 (DC General) **/
  if cjrTractBl in ( '6804 1010' ) then do;

    Ward2012b = '7';
    
  end;
  /** Correction: tract 49.02, block 2000 (Convention Center) -> Ward 6 (houses along 7th Street) **/
  else if cjrTractBl in ( '4902 2000' ) then do;

    Ward2012b = '6';
    
  end;
  else do;
  
    Ward2012b = put( ward, 1. );
    
  end;
  
  label 
    Ward2012b = 'Ward (2012, draft 6/8/11)'
    Ward2002 = 'Ward (2002)';

  label 
    CJRTRACTBL = "OCTO tract/block ID"
    Ward = "Ward code"
    X = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    Y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove conflicting duplicate obs. **;

  *****if GEOBLK2000 = "110010068041004" and Ward2002 ~= "7" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  format x y 10.2;
  
  keep Geo2000 GeoBlk2000 Ward2002 Ward2012b CJRTRACTBL Ward x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_ward12b,
  by=GeoBlk2000,
  id=Ward2002 Ward2012b
)

proc sort data=General.Block00_ward12b nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_ward12b, stats=, freqvars=Ward2002 Ward2012b  )

proc freq data=General.Block00_ward12b;
  tables Ward2002 * Ward2012b / missing list;
run;

** Display changes **;

proc sort data=General.Block00_ward12b out=Block00_ward12b;
  by Ward2002 Ward2012b;

proc print data=Block00_ward12b noobs;
  where Ward2002 ~= Ward2012b;
  by Ward2002 Ward2012b;
  var GeoBlk2000 CJRTRACTBL Ward;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0wdbf,
  Data=General.Block00_ward12b,
  Value=GeoBlk2000,
  Label=Ward2012b,
  OtherLabel="",
  Desc="Block 2000 to Ward 2012b correspondence",
  Print=N,
  Contents=Y
  )

