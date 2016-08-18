/**************************************************************************
 Program:  ZIP.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/17/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  ZIP code names data set and formats.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( General )
%DCData_lib( Octo )

** DBMS/Engines library to read DBF file **;

libname dbmsdbf dbdbf "D:\DCData\Libraries\OCTO\Maps" ver=4 width=12 dec=2 Zip=ZipCodePly;

** Create data set **;

data General.ZIP (label="List of DC ZIP codes");

  set dbmsdbf.Zip;
  
  %Octo_zip()
  
  length Zip_name $ 9;

  Zip_name = "ZIP " || ZIP;
  
  label 
    ZIP_name = "ZIP code (5-digit), name"
    ;
  
  keep ZIP ZIP_name;
  
run;

proc sort data=General.ZIP nodupkey;
  by ZIP;

%file_info( data=General.ZIP, printobs=100, stats= )

** Create formats **;

** $zipa:  ZIP xxxxx **;

%Data_to_format(
  FmtLib=General,
  FmtName=$zipa,
  Data=General.ZIP,
  Value=ZIP,
  Label=ZIP_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** $zipv:  
** Validation format - returns ZIP code if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$zipv,
  Data=General.ZIP,
  Value=ZIP,
  Label=ZIP,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )


proc catalog catalog=general.formats entrytype=formatc;
  modify zipa (desc="ZIP codes, 'ZIP nnnnn'");
  modify zipv (desc="ZIP codes, validation");
  contents;
  quit;
  
** Add $zipa format to data set **;

proc datasets library=General nolist memtype=(data);
  modify ZIP;
    format ZIP $zipa.;
quit;

