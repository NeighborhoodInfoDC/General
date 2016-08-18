** PROGRAM NAME: Dcformats_export_64bit.sas
**
** DESCRIPTION :  Export formats catalog to dataset so it can be imported as catalog under 64-bit Windows 7

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

rsubmit;
proc download status=no incat=general.formats outcat=dcfmts.formats;
run;
endrsubmit;

proc format library=dcfmts cntlout=dcfmts.dccntl;
run;

signoff;