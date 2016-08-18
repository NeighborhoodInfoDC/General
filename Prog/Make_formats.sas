/**************************************************************************
 Program:  Make_formats.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/15/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create formats for General library.

 Modifications:
  02/17/06  Added format descriptions.
  04/05/06  Added $hmt05f and $clhmt5f.
  08/27/06  Added suppr5f.
  07/07/12  Added $eorv.
  09/05/12  Added $yesno.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;

proc format library=General;

  value dyesno
    0 = "No"
    1 = "Yes";
    
  value $yesno (notsorted)
    "Y" = "Yes"
    "N" = "No";
    
  picture suppr5f (default=8 round)
    low -< 0 = 'Invalid!'
    0 = '0' (noedit)
    0 <-< 4.5 = '<5' (noedit)
    4.5 - high = '00000009';

  value $city
    "1" = "Washington, D.C.";

  value $eor 
    "1" = "East of the River"
    "9" = "Not East of the River";
    
  value $eorv
    "1" = "1"
    "9" = "9"
    other = " ";

  value $cnb03f
    "1" = "Deanwood"
    "2" = "Marshall Heights"
    "3" = "Ft. Dupont Park"
    "9" = "Outside Casey target neighborhoods";
  
  value $cta03f
    "1" = "Inside Casey target neighborhoods"
    "9" = "Outside Casey target neighborhoods";
  
  value $hmt05f
    "1" = "Deanwood Group"
    "2" = "Ivy City Group"
    "3" = "Takoma Group"
    "4" = "Mt. Pleasant Group"
    "5" = "Capitol Hill Group"
    "6" = "Cleveland Park Group"
    "7" = "Downtown Group"
    "9" = "Non-cluster area";
  
  value $clhmt5f
    "29" = "1"
    "30" = "1"
    "31" = "1"
    "32" = "1"
    "33" = "1"
    "34" = "1"
    "36" = "1"
    "38" = "1"
    "39" = "1"

    "23" = "2"
    "27" = "2"
    "28" = "2"
    "37" = "2"

    "17" = "3"
    "18" = "3"
    "19" = "3"
    "20" = "3"
    "22" = "3"
    "24" = "3"
    "35" = "3"

    "02" = "4"
    "07" = "4"
    "21" = "4"
    "25" = "4"
    
    "03" = "5"
    "26" = "5"

    "04" = "6"
    "10" = "6"
    "11" = "6"
    "13" = "6"
    "15" = "6"
    "16" = "6"
  
    "01" = "7"
    "05" = "7"
    "06" = "7"
    "08" = "7"
    "09" = "7"
    "12" = "7"
    "14" = "7"
    
    "99" = "9"
    other = " ";
  
run;

** Label numeric formats **;

proc catalog catalog=general.formats entrytype=format;
  modify dyesno (desc="Yes/No dummy var (0/1)");
  modify suppr5f (desc="Suppress values < 5");
  quit;

** Label character formats (NB: Omit $ before format name) **;

proc catalog catalog=general.formats entrytype=formatc;
  modify yesno (desc="Yes/No char var (Y/N)");
  modify city (desc="Washington, D.C. geo label");
  modify eor (desc="East of the River, geo label");
  modify cnb03f (desc="Casey nbrhds (2003), individual");
  modify cta03f (desc="Casey target area (2003)");
  modify hmt05f (desc="UI housing market typology (2005)");
  modify clhmt5f (desc="Nbr clus 00 to hsng market typ 05 corres");
  modify eorv (desc="East of the River, validation");
  quit;

** Print contents of catalog **;
  
proc catalog catalog=general.formats;
  contents;
  quit;
