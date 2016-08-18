/**************************************************************************
 Program:  Format_cnty99f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/02/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create $CNTY99F - labels for counties in 
 1999 Washington, DC-MD-VA-WV PMSA definition.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

proc format library=General;
  value $cnty99f
    "11001" = "District of Columbia"
    "24009" = "Calvert County, MD"
    "24017" = "Charles County, MD"
    "24021" = "Frederick County, MD"
    "24031" = "Montgomery County, MD"
    "24033" = "Prince George's County, MD"
    "51013" = "Arlington County, VA"
    "51043" = "Clarke County, VA"
    "51047" = "Culpeper County, VA"
    "51059" = "Fairfax County, VA"
    "51061" = "Fauquier County, VA"
    "51099" = "King George County, VA"
    "51107" = "Loudoun County, VA"
    "51153" = "Prince William County, VA"
    "51177" = "Spotsylvania County, VA"
    "51179" = "Stafford County, VA"
    "51187" = "Warren County, VA"
    "51510" = "Alexandria city, VA"
    "51600" = "Fairfax city, VA"
    "51610" = "Falls Church city, VA"
    "51630" = "Fredericksburg city, VA"
    "51683" = "Manassas city, VA"
    "51685" = "Manassas Park city, VA"
    "54003" = "Berkeley County, WV"
    "54037" = "Jefferson County, WV";
  
run;

proc catalog catalog=General.formats;
  modify cnty99f (desc="County labels 1999 PMSA def") / entrytype=formatc;
  contents;
quit;

