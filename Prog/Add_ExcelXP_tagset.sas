/**************************************************************************
 Program:  Add_ExcelXP_tagset.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  07/05/19
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  
 
 Description:  Submit code for latest version of ExcelXP tagset to
 add to local SAS setup. Each SAS user must run this code (once) on
 their own machine to add the tagset. 

 Latest version: 04/23/2015, version 1.131, downloaded from
 http://support.sas.com/rnd/base/ods/odsmarkup/index.html

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;


** Submit ExcelXP tagset definition **;

%include "&_dcdata_default_path\General\Prog\excltags.tpl";


run;
