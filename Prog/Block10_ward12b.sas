************************************************************************
* Program:  Block10_ward12b.sas
* Library:  General
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  05/31/11
* Version:  SAS 9.2
* Environment:  Windows
* 
* Description:  Create Census 2010 block to Ward (2012, draft 6/8/11) file 
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

data General.Block10_ward12b 
  (label="Census 2010 blocks (GeoBlk2010) to Wards (Ward2012b) correspondence file");

  set General.Block10_ward12_draft_Jun8;
  
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
  
  ** Create Ward2012b var **;
  
  length Ward2012b $ 1;
  
  /** Correction: tract 68.04, block 1010 (Congressional Cemetery) -> Ward 7 (DC General) **/
  if tract = '006804' and block = '1011' then do;

    Ward2012b = '7';
    
  end;
  /** Correction: tract 49.02, block 2000 (Convention Center) -> Ward 6 (houses along 7th Street) **/
  else if tract = '004902' and block = '2000' then do;

    Ward2012b = '6';
    
  end;
  else do;
  
    Ward2012b = put( ward, 1. );
    
  end;
  
  label 
    Ward2012b = 'Ward (2012, draft 6/8/11)'
    Ward2002 = 'Ward (2002)';

  label 
    ward = "Ward code"
    Tract = "OCTO tract ID"
    BlkGrp = "OCTO block group ID"
    Block = "OCTO block ID"
  ;
  
  ** Remove conflicting duplicate obs. **;

  *****if GeoBlk2010 = "110010068041004" and Ward2002 ~= "7" then delete;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Ward2002 Ward2012b Tract BlkGrp Block Ward;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block10_ward12b,
  by=GeoBlk2010,
  id=Ward2002 Ward2012b
)

proc sort data=General.Block10_ward12b nodupkey;
  by GeoBlk2010;

%File_info( data=General.Block10_ward12b, stats=, freqvars=Ward2002 Ward2012b  )

proc freq data=General.Block10_ward12b;
  tables Ward2002 * Ward2012b / missing list;
run;

** Display changes **;

proc sort data=General.Block10_ward12b out=Block10_ward12b;
  by Ward2002 Ward2012b;

proc print data=Block10_ward12b noobs;
  where Ward2002 ~= Ward2012b;
  by Ward2002 Ward2012b;
  var GeoBlk2010 Tract BlkGrp Block Ward;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1wdbf,
  Data=General.Block10_ward12b,
  Value=GeoBlk2010,
  Label=Ward2012b,
  OtherLabel="",
  Desc="Block 2010 to Ward 2012b correspondence",
  Print=N,
  Contents=Y
  )

