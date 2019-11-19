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

  input psa2019 $3. psa2019_name & $99.; 

  label 
    psa2019 = 'Police Service Area (2019)'
    psa2019_name = 'Police Service Area (2019) Name';

datalines;
308	Police Service Area: 308
301	Police Service Area: 301
305	Police Service Area: 305
402	Police Service Area: 402
406	Police Service Area: 406
201	Police Service Area: 201
401	Police Service Area: 401
209	Police Service Area: 209
307	Police Service Area: 307
102	Police Service Area: 102
107	Police Service Area: 107
303	Police Service Area: 303
208	Police Service Area: 208
505	Police Service Area: 505
501	Police Service Area: 501
304	Police Service Area: 304
306	Police Service Area: 306
408	Police Service Area: 408
502	Police Service Area: 502
409	Police Service Area: 409
302	Police Service Area: 302
504	Police Service Area: 504
204	Police Service Area: 204
503	Police Service Area: 503
205	Police Service Area: 205
407	Police Service Area: 407
404	Police Service Area: 404
405	Police Service Area: 405
203	Police Service Area: 203
403	Police Service Area: 403
202	Police Service Area: 202
104	Police Service Area: 104
105	Police Service Area: 105
206	Police Service Area: 206
601	Police Service Area: 601
602	Police Service Area: 602
506	Police Service Area: 506
708	Police Service Area: 708
706	Police Service Area: 706
705	Police Service Area: 705
707	Police Service Area: 707
704	Police Service Area: 704
702	Police Service Area: 702
703	Police Service Area: 703
701	Police Service Area: 701
607	Police Service Area: 607
605	Police Service Area: 605
103	Police Service Area: 103
106	Police Service Area: 106
603	Police Service Area: 603
108	Police Service Area: 108
507	Police Service Area: 507
606	Police Service Area: 606
604	Police Service Area: 604
207	Police Service Area: 207
608	Police Service Area: 608
101	Police Service Area: 101

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
  FmtName=$psa17v
,
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
  modify psa17a (desc="Police Service Areas (2019), 'psa nn'");
  modify psa17b (desc="Police Service Areas (2019), psa names only");
  modify psa17f (desc="Police Service Areas (2019), 'psa nn (..)'");
  modify psa17g (desc="Police Service Areas (2019), 'nn (..)'");
  modify psa17v (desc="Police Service Areas (2019), validation");
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

