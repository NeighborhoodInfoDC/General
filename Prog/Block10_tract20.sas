/************************************************************************
  Program:  Block10_tract20.sas
  Library:  General
  Project:  Urban-Greater DC
  Author:   L. Hendey
  Created:  05/03/24
  Version:  SAS 9.4
  Environment:  Windows
  
  Description:  Create Census 2020 block to Tract (2020) 
  correspondence file.

  Adds correspondence format $bk1tr2f. to local General library.

  Modifications:
************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;
 data Block10_geo2020_Csv;
    %let _EFIERR_ = 0; /* Set the ERROR detection macro variable */

    infile '\\sas1\dcDATA\Libraries\General\Maps\Census 2010\Block10_tract20.csv'
           delimiter=','
           MISSOVER
           DSD
           lrecl=32767
           firstobs=2;

    informat 
        TRACT $6. 
        BLKGRP $1. 
        BLOCK $4. 
        TRACT_1 $6. 
        GEOID $11.;

    input 
        FID
        FID_1
        TRACT $
        BLKGRP $
        BLOCK $
        SHAPE_AREA
        SHAPE_LEN
        ORIG_FID
        FID_2
        OBJECTID
        TRACT_1 $
        GEOID $
        P0010001
        P0010002
        P0010003
        P0010004
        P0010005
        P0010006
        P0010007
        P0010008
        P0020002
        P0020005
        P0020006
        P0020007
        P0020008
        P0020009
        P0020010
        P0030001
        P0030003
        P0030004
        P0030005
        P0030006
        P0030007
        P0030008
        P0040002
        P0040005
        P0040006
        P0040007
        P0040008
        P0040009
        P0040010
        H0010001
        H0010002
        H0010003
        ALAND
        AWATER
        STUSAB $
        SUMLEV
        GEOCODE
        STATE
        NAME $
        POP100
        HU100
        P0010009
        P0010010
        P0010011
        P0010012
        P0010013
        P0010014
        P0010015
        P0010016
        P0010017
        P0010018
        P0010019
        P0010020
        P0010021
        P0010022
        P0010023
        P0010024
        P0010025
        P0010026
        P0010027
        P0010028
        P0010029
        P0010030
        P0010031
        P0010032
        P0010033
        P0010034
        P0010035
        P0010036
        P0010037
        P0010038
        P0010039
        P0010040
        P0010041
        P0010042
        P0010043
        P0010044
        P0010045
        P0010046
        P0010047
        P0010048
        P0010049
        P0010050
        P0010051
        P0010052
        P0010053
        P0010054
        P0010055
        P0010056
        P0010057
        P0010058
        P0010059
        P0010060
        P0010061
        P0010062
        P0010063
        P0010064
        P0010065
        P0010066
        P0010067
        P0010068
        P0010069
        P0010070
        P0010071
        P0020001
        P0020003
        P0020004
        P0020011
        P0020012
        P0020013
        P0020014
        P0020015
        P0020016
        P0020017
        P0020018
        P0020019
        P0020020
        P0020021
        P0020022
        P0020023
        P0020024
        P0020025
        P0020026
        P0020027
        P0020028
        P0020029
        P0020030
        P0020031
        P0020032
        P0020033
        P0020034
        P0020035
        P0020036
        P0020037
        P0020038
        P0020039
        P0020040
        P0020041
        P0020042
        P0020043
        P0020044
        P0020045
        P0020046
        P0020047
        P0020048
        P0020049
        P0020050
        P0020051
        P0020052
        P0020053
        P0020054
        P0020055
        P0020056
        P0020057
        P0020058
        P0020059
        P0020060
        P0020061
        P0020062
        P0020063
        P0020064
        P0020065
        P0020066
        P0020067
        P0020068
        P0020069
        P0020070
        P0020071
        P0020072
        P0020073
        P0030002
        P0030009
        P0030010
        P0030011
        P0030012
        P0030013
        P0030014
        P0030015
        P0030016
        P0030017
        P0030018
        P0030019
        P0030020
        P0030021
        P0030022
        P0030023
        P0030024
        P0030025
        P0030026
        P0030027
        P0030028
        P0030029
        P0030030
        P0030031
        P0030032
        P0030033
        P0030034
        P0030035
        P0030036
        P0030037
        P0030038
        P0030039
        P0030040
        P0030041
        P0030042
        P0030043
        P0030044
        P0030045
        P0030046
        P0030047
        P0030048
        P0030049
        P0030050
        P0030051
        P0030052
        P0030053
        P0030054
        P0030055
        P0030056
        P0030057
        P0030058
        P0030059
        P0030060
        P0030061
        P0030062
        P0030063
        P0030064
        P0030065
        P0030066
        P0030067
        P0030068
        P0030069
        P0030070
        P0030071
        P0040001
        P0040003
        P0040004
        P0040011
        P0040012
        P0040013
        P0040014
        P0040015
        P0040016
        P0040017
        P0040018
        P0040019
        P0040020
        P0040021
        P0040022
        P0040023
        P0040024
        P0040025
        P0040026
        P0040027
        P0040028
        P0040029
        P0040030
        P0040031
        P0040032
        P0040033
        P0040034
        P0040035
        P0040036
        P0040037
        P0040038
        P0040039
        P0040040
        P0040041
        P0040042
        P0040043
        P0040044
        P0040045
        P0040046
        P0040047
        P0040048
        P0040049
        P0040050
        P0040051
        P0040052
        P0040053
        P0040054
        P0040055
        P0040056
        P0040057
        P0040058
        P0040059
        P0040060
        P0040061
        P0040062
        P0040063
        P0040064
        P0040065
        P0040066
        P0040067
        P0040068
        P0040069
        P0040070
        P0040071
        P0040072
        P0040073
        P0050001
        P0050002
        P0050003
        P0050004
        P0050005
        P0050006
        P0050007
        P0050008
        P0050009
        P0050010
        SHAPEAREA
        SHAPELEN
        Distance;

run;




data Block10_Tract20 
  (label="Census 2010 blocks (GeoBlk2010) to Tracts (Geo2020) correspondence file");

  set Block10_geo2020_csv;
  
    length GeoBlk2010 $ 16 GeoBg2010 $ 12 Geo2010 $ 11 ;
  ** Census 2010 block ID **;
	GeoBlk2010= '11001' || trim( left( Tract ) ) || left( Block );
	GeoBg2010= '11001' || trim( left( Tract ) ) || trim( left( blkgrp ) );

  ** Census tract, block group ID (needed for creating weight files) **;

  Geo2010 = GeoBlk2010;


  label 
  	GeoBlk2010="Full census block ID (2010): sscccttttttbbbb"
    GeoBg2010 = "Full census block group ID (2010): sscccttttttb"
    GEO2010 = "Full census tract ID (2010): ssccctttttt";

  ** Geo2020 var **;

  %Octo_Geo2020 ( check=y )

  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2010 GeoBg2010 Geo2010 Geo2020;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=Block10_Tract20,
  by=GeoBlk2010,
  id=Geo2020
)

proc sort data=Block10_Tract20 nodupkey;
  by GeoBlk2010;
run;

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk1tr2f,
  Data=Block10_Tract20,
  Value=GeoBlk2010,
  Label=Geo2020,
  OtherLabel="",
  Desc="Block 2010 to Tract 2020 correspondence",
  Print=N,
  Contents=Y
  )

%Finalize_data_set(
    data=Block10_Tract20,
    out=Block10_Tract20,
    outlib=general,
    label="Census 2010 blocks (GeoBlk2010) to Tract 2020 (geo2020) correspondence file",
    sortby=GeoBlk2010,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )
