/**************************************************************************
 Program:  Format_cnty03f.sas  (compatibility bundle)
 Library:  General
 Project:  NeighborhoodInfo DC

 Description:  Create $cnty03f - labels for counties in
 2003 Metropolitan/micropolitan statistical area definition.

 Adapted from Prog/Format_cnty03f.sas: the format now builds into WORK
 (the original targets the General format catalog), and the run prints
 the resulting format so the listing is self-checking. The value block
 below is verbatim from the repository.
**************************************************************************/

proc format library=work;
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

** Print the format so the run verifies the county labels built correctly **;

proc format library=work fmtlib;
  select $cnty03f;
run;
