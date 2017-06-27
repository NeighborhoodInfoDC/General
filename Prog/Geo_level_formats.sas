/**************************************************************************
 Program:  Geo_level_formats.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/31/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create special formats for processing geographic
 levels.  Information is taken from the Excel workbook
 
 D:\DCData\Libraries\General\Doc\Geographic levels.xlsx
 
 which must be open before this program is run.

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
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
libname doc 'L:\Libraries\General\Doc';

/** Macro Create_format - Start Definition **/

%macro Create_format( name=, col=, desc= );

%let start_row = 5;
%let end_row = 31;

/* Updated code for StatTransfer */

data xlsFileA;
	set doc.geolevels;
	if &start_row. <= _n_ <= &end_row.;
	keep c5;
	rename c5 = VarName;
run;

data xlsFileb;
	set doc.geolevels;
	if &start_row. <= _n_ <= &end_row.;
	keep c&col.;
	rename c&col. = xValue;
run;

data FmtIn;
	merge xlsFileA xlsFileb;
	if xValue not in ( "", "-" );
run;


%Data_to_format(
  FmtLib=General,
  FmtName=&name,
  Data=FmtIn,
  Value=upcase(VarName),
  Label=xValue,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y,
  Desc=&desc,
  Contents=N
  )

filename _all_ clear;


run;

%mend Create_format;

/** End Macro Definition **/

%Create_format( name=$geoval, col=5, desc="Validate geography name" )

%Create_format( name=$geolen, col=6, desc="Geo name to geography var length" )

%Create_format( name=$geosuf, col=3, desc="Geo name to file name suffix" )

%Create_format( name=$geolbl, col=1, desc="Geo name to geography label" )

/** Next two are repeated to accomodate original format names $GEOTWTF AND $GEOBWTF **/

%Create_format( name=$geotwtf, col=10, desc="Geo name to tract 2000 weighting file" )

%Create_format( name=$geobwtf, col=11, desc="Geo name to block grp 00 weighting file" )

%Create_format( name=$geotw0f, col=10, desc="Geo name to tract 2000 weighting file" )

%Create_format( name=$geobw0f, col=11, desc="Geo name to block grp 00 weighting file" )

%Create_format( name=$geotw1f, col=12, desc="Geo name to tract 2010 weighting file" )

%Create_format( name=$geobw1f, col=13, desc="Geo name to block grp 10 weighting file" )

%Create_format( name=$geoafmt, col=15, desc="Geo name to geography label format" )

%Create_format( name=$geovfmt, col=16, desc="Geo name to geography validation format" )

%Create_format( name=$geobk0f, col=17, desc="Geo name to 2000 block corresp. format" )

%Create_format( name=$geotr0f, col=18, desc="Geo name to 2000 tract corresp. format" )

%Create_format( name=$geobk1f, col=19, desc="Geo name to 2010 block corresp. format" )

%Create_format( name=$geotr1f, col=20, desc="Geo name to 2010 tract corresp. format" )

%Create_format( name=$geodlbl, col=21, desc="Geo name to data set label" )

%Create_format( name=$geoslbl, col=22, desc="Geo name to short label" )

%Create_format( name=$geobk0m, col=23, desc="Geo name to 2000 block macro name" )

%Create_format( name=$geobk1m, col=24, desc="Geo name to 2010 block macro name" )

proc catalog catalog=General.formats;
  contents;
quit;

/* End of Program */
