/**************************************************************************
 Program:  Geo_level_formats.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Updated:  12/12/2019
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create special formats for processing geographic
 levels.  Information is taken from the Excel workbook
 
 \\sas1\DCData\Libraries\General\Doc\Geographic levels.xlsx
 
 which must be saved to this CSV file before this program is run.
 
 \\sas1\DCData\Libraries\General\Doc\Geographic levels.csv

 Modifications:
  12/08/06 PAT  Added $GEODLBL format.
  04/02/07 PAT  Added $GEOSLBL format.
  12/19/10 PAT  Updated formats to add block groups.
                Added format for block 2000 correspondence ($geobk0f).
  03/23/11 PAT  Added Census 2010 geography formats, tract corresp formats.
  07/15/11 PAT  Added PG Council Districts as a geographic level.
  07/07/12 PAT  Added new DC geos: Anc2012, Psa2012, Ward2012.
                Added validation format for EOR.
  02/14/17 JD	Updated to run on L:\ Drive.
				Added new geo: Bridge Park.
  03/07/17 RP   Updated code to remove the DDE. Geographic Levels file must 
				first be converted to a SAS dataset in StatTransfer. 
  04/27/18 YS   Added new geo: StantonCommons
  09/08/21 RP   Added new geographies from 2020 Census update.
  02/07/22 EB	Added new geo: Ward (2022)
  02/16/24 PT   Change code to use import from CSV file created from XLSX.
                Added new geo COUNTY (all counties).
  04/30/25 RP	Added new geo: ANC (2023)
**************************************************************************/

%include "\\sas1\dcdata\SAS\Inc\StdLocal.sas";

** Define libraries **;


** Get geographic level information **;

filename fimport "&_dcdata_r_path\General\Doc\Geographic levels.csv" lrecl=2000;

proc import out=FmtIn
  datafile=fimport
  dbms=csv replace;
  datarow=6;
  getnames=yes;
  guessingrows=100;
run;

filename fimport clear;

data FmtIn;

  set FmtIn;
  
  where not( missing( geoval ) );
  
  array a{*} _character_;
  
  do i = 1 to dim( a );
    if left( a{i} ) = '-' then a{i} = '';
  end;
  
  length xgeolen $ 8;
  
  if geolen > 0 then xgeolen = left( put( geolen, 8. ) );
  
  drop i var: geolen;
  rename xgeolen=geolen;

run;


/** Macro Create_format - Start Definition **/

%macro Create_format( name=, format=, desc= );

  %if %length( &format ) = 0 %then %let format = &name;

  %Data_to_format(
    FmtLib=General,
    FmtName=$&format,
    Data=FmtIn,
    Value=upcase(geoval),
    Label=&name,
    OtherLabel="",
    Print=Y,
    Desc=&desc,
    Contents=N
    )

run;

%mend Create_format;

/** End Macro Definition **/

%Create_format( name=geoval, desc="Validate geography name" )

%Create_format( name=geolen, desc="Geo name to geography var length" )

%Create_format( name=geosuf, desc="Geo name to file name suffix" )

%Create_format( name=geolbl, desc="Geo name to geography label" )

/** Next two are repeated to accomodate original format names $GEOTWTF AND $GEOBWTF for 2000 **/

%Create_format( name=geotw0f, format=geotwtf, desc="Geo name to tract 2000 weighting file" )

%Create_format( name=geobw0f, format=geobwtf, desc="Geo name to block grp 00 weighting file" )

%Create_format( name=geotw0f, desc="Geo name to tract 2000 weighting file" )

%Create_format( name=geobw0f, desc="Geo name to block grp 00 weighting file" )

%Create_format( name=geotw1f, desc="Geo name to tract 2010 weighting file" )

%Create_format( name=geobw1f, desc="Geo name to block grp 10 weighting file" )

%Create_format( name=geotw2f, desc="Geo name to tract 2020 weighting file" )

%Create_format( name=geobw2f, desc="Geo name to block grp 20 weighting file" )

%Create_format( name=geoafmt, desc="Geo name to geography label format" )

%Create_format( name=geovfmt, desc="Geo name to geography validation format" )

%Create_format( name=geobk0f, desc="Geo name to 2000 block corresp. format" )

%Create_format( name=geotr0f, desc="Geo name to 2000 tract corresp. format" )

%Create_format( name=geobk1f, desc="Geo name to 2010 block corresp. format" )

%Create_format( name=geotr1f, desc="Geo name to 2010 tract corresp. format" )

%Create_format( name=geobk2f, desc="Geo name to 2020 block corresp. format" )

%Create_format( name=geotr2f, desc="Geo name to 2020 tract corresp. format" )

%Create_format( name=geodlbl, desc="Geo name to data set label" )

%Create_format( name=geoslbl, desc="Geo name to short label" )

%Create_format( name=geobk0m, desc="Geo name to 2000 block macro name" )

%Create_format( name=geobk1m, desc="Geo name to 2010 block macro name" )

%Create_format( name=geobk2m, desc="Geo name to 2020 block macro name" )


proc catalog catalog=General.formats;
  contents;
quit;

/* End of Program */
