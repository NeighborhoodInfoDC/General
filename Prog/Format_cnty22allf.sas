/**************************************************************************
 Program:  Format_cnty22allf.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  01/25/24
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  146
 
 Description:  Create format for all 2022 ACS counties in DC, MD, VA, WV.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

%Get_census_api(
  out=cnty22,
  api='https://api.census.gov/data/2022/acs/acs5?get=NAME&for=county:*&in=state:11,24,51,54'
)

%Data_to_format(
  FmtLib=General,
  FmtName=$cnty22allf,
  Desc="County labels 2022 all counties in DC MD VA WV",
  Data=cnty22,
  Value=trim( state ) || trim( county ),
  Label=trim( name ),
  OtherLabel=,
  Print=Y,
  Contents=Y
  )

