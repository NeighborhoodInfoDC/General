/**************************************************************************
 Program:  Format_Tr0is4f.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/02/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Correspondence format between tracts 
 Issue Scan 2004 focus neighborhoods ($Tr0is4f).

   1 = Columbia Heights
   2 = Shaw
   3 = Congress Heights
   4 = Navy Yard
   5 = Deanwood*
   6 = Marshall Heights*
   7 = Ft. Dupont Park*
   9 = Other neighborhoods
   
   *Casey target area neighborhoods

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )

data Tr00_isn04 (compress=no);

  length ISN2004 $ 1 GEO2000 $ 11 ;

  input isn2004 geo2000;

cards;
1 11001002701
1 11001002702
1 11001002801
1 11001002802
1 11001002900
1 11001003000
1 11001003100
1 11001003200
1 11001003400
1 11001003500
1 11001003600
1 11001003700
1 11001004300
1 11001004400
1 11001005000
1 11001005201
2 11001004801
2 11001004802
2 11001004901
2 11001004902
3 11001007302
3 11001007304
3 11001007404
3 11001009700
3 11001009801
3 11001009802
3 11001009803
3 11001009804
3 11001009806
3 11001009807
3 11001009808
3 11001009809
4 11001006001
4 11001006002
4 11001006100
4 11001006201
4 11001006301
4 11001006302
4 11001006401
4 11001007100
4 11001007200
5 11001007804
5 11001007808
5 11001009903
6 11001009904
6 11001009905
6 11001009906
7 11001007703
7 11001007707
7 11001009907
;

run;

%Data_to_format( 
  FmtLib=General,
  FmtName=$Tr0is4f,
  Data=Tr00_isn04,
  Value=geo2000, 
  Label=isn2004,
  OtherLabel="9",
  DefaultLen=., 
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

proc catalog catalog=general.formats entrytype=formatc;
  modify Tr0is4f (desc="Tract (2000)-Issue Scan nbrhd corresp.");
  contents;
  quit;
  
