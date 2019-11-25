/**************************************************************************
 Program:  PSA2019.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Eleanor Noble
 Created:  11/19/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  DC PSA names data set and formats.

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** Create data set **;

data PSA2019 (label="Police Service Area (2019)");

  input psa2019 $3. psa2019_name & $10.; 

  label 
    psa2019 = 'Police Service Area (2019)'
    psa2019_name = 'Police Service Area (2019) Name';

datalines;
308	PSA 308
301	PSA 301
305	PSA 305
402	PSA 402
406	PSA 406
201	PSA 201
401	PSA 401
209	PSA 209
307	PSA 307
102	PSA 102
107	PSA 107
303	PSA 303
208	PSA 208
505	PSA 505
501	PSA 501
304	PSA 304
306	PSA 306
408	PSA 408
502	PSA 502
409	PSA 409
302	PSA 302
504	PSA 504
204	PSA 204
503	PSA 503
205	PSA 205
407	PSA 407
404	PSA 404
405	PSA 405
203	PSA 203
403	PSA 403
202	PSA 202
104	PSA 104
105	PSA 105
206	PSA 206
601	PSA 601
602	PSA 602
506	PSA 506
708	PSA 708
706	PSA 706
705	PSA 705
707	PSA 707
704	PSA 704
702	PSA 702
703	PSA 703
701	PSA 701
607	PSA 607
605	PSA 605
103	PSA 103
106	PSA 106
603	PSA 603
108	PSA 108
507	PSA 507
606	PSA 606
604	PSA 604
207	PSA 207
608	PSA 608
101	PSA 101

;
  
run;

**sort procedure changed the right order?**;
proc sort data=psa2019;
  by psa2019;
run;


** Create formats **;

** $psa2019a: psa nn **;

%Data_to_format(
  FmtLib=General,
  FmtName=$psa2019a,
  Data=PSA2019,
  Value=psa2019,
  Label="Police Service Area " || psa2019,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


** $psa2019b:  NeiName **;

%Data_to_format(
  FmtLib=General,
  FmtName=$psa2019b,
  Data=PSA2019,
  Value=psa2019,
  Label=psa2019_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $psa19f: psa nn (...) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$psa2019f,
  Data=PSA2019,
  Value=psa2019,
  Label="Police Service Area " || trim( Cluster2017 ) || " (" || trim( cluster2017_name ) || ")",
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );

** $psa17g: nn (...) **;

%Data_to_format(
  FmtLib=General,
  FmtName=$psa2019g,
  Data=PSA2019,
  Value=PSA2019,
  Label=trim( PSA2019 ) || " (" || trim( psa2019_name ) || ")",
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


** $psa17v:  
** Validation format - returns PSA2019 number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$psa19v,
  Data=PSA2019,
  Value=CPSA2019,
  Label=PSA2019,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  );


proc catalog catalog=General.formats entrytype=formatc;
  modify psa19a (desc="Police Service Areas (2019), 'psa nn'");
  modify psa19b (desc="Police Service Areas (2019), psa names only");
  modify psa19f (desc="Police Service Areas (2019), 'psa nn (..)'");
  modify psa19g (desc="Police Service Areas (2019), 'nn (..)'");
  modify psa19v (desc="Police Service Areas (2019), validation");
  contents;
  quit;

** Add $psa19a format to data set **;

proc datasets library=Work nolist memtype=(data);
  modify psa2019;
    format psa2019 $psa19a.;
quit;

** Save final dataset to SAS1 **;

%Finalize_data_set( 
  data=PSA2019,
  out=psa2019,
  outlib=General,
  label="Police Service Areas (2019)",
  stats=,
  sortby=psa2019,
  restrictions=None,
  revisions=Added new cluster display formats.
  );

%file_info( data=General.PSA2019, printobs=5, stats= )


/* End of Program */

