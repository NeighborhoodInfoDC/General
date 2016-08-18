** PROGRAM NAME: Uiformats_import_64bit.sas
**
** PROJECT:  NatData
** DESCRIPTION :  Import formats dataset as 64-bit formats catalog

** ASSISTING PROGRAMS:
** PREVIOUS PROGRAM:
** FOLLOWING PROGRAM:
**
** AUTHOR      :  R. Rosso
**
** CREATED     :  12-5-11
** MODIFICATIONS: 
**   
**
*******************************************************************************;

libname dcfmts "D:\DCData\Libraries\General\Data\formatsw7";

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( General )

Proc format library=dcfmts cntlin=dcfmts.dccntl;
Run;

rsubmit;
libname dcfmts "[dcdata.general.data.formatsw7]";

proc upload status=no incat=dcfmts.formats outcat=dcfmts.formats;
run;
endrsubmit;

signoff;