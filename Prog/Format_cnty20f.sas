/**************************************************************************
 Program:  Format_cnty20f.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  9/19/21
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create $cnty20f - labels for counties in 
 2020 Metropolitan/micropolitan statistical area definition.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

proc format library=General;
  value $cnty20f
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
    "51107" = "Loudoun County, VA"
    "51113" = "Madison County, VA"
    "51153" = "Prince William County, VA"
    "51157" = "Rappahannock County, VA"
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
  modify cnty20f (desc="County labels 2020 MSA def") / entrytype=formatc;
  contents;
quit;

