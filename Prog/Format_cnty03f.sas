/**************************************************************************
 Program:  Format_cnty03f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/29/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create $cnty03f - labels for counties in 
 2003 Metropolitan/micropolitan statistical area definition.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

proc format library=General;
  value $cnty03f
    "11001" = "District of Columbia, DC"
    "24009" = "Calvert County, MD"
    "24017" = "Charles County, MD"
    "24021" = "Frederick County, MD"
    "24031" = "Montgomery County, MD"
    "24033" = "Prince George's County, MD"
    "51013" = "Arlington County, VA"
    "51043" = "Clarke County, VA"
    "51059" = "Fairfax County, VA"
    "51061" = "Fauquier County, VA"
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
    "54037" = "Jefferson County, WV";
  
run;

proc catalog catalog=General.formats;
  modify cnty03f (desc="County labels 2003 MSA def") / entrytype=formatc;
  contents;
quit;

