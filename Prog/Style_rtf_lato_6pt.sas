/**************************************************************************
 Program:  Style_rtf_lato_6pt.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/15/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create ODS style Rtf_lato_6pt.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

** New style for RTF output **;

proc template;
  define style Styles.Rtf_lato_6pt;
    parent=styles.rtf;
       style Table from Output /
             /** Cell background color **/
             Background=_undef_
             /** Lines between columns and rows **/
             Rules=groups
             /** Lines around table **/
             frame=hsides
             /** Cell padding **/
             cellpadding = 1pt;
       style header from header /
             /** Background color for col. headers **/
             background=_undef_
             /** Don't change this (enables RTF special characters) **/
             protectspecialchars=off;
       style rowheader from rowheader /
             /** Background color for row headers **/
             background=_undef_
             /** Font for row headers **/
             font=fonts('docFont')
             /** Don't change this (enables RTF special characters) **/
             protectspecialchars=off;
       replace fonts /
        /** Main table font **/
        'docFont' = ("lato",6pt)
        /** Heading fonts **/
        'headingEmphasisFont' = ("lato",6pt,Bold Italic)
        'headingFont' = ("lato",6pt,Bold)
        'StrongFont' = ("lato",6pt,Bold)
        'EmphasisFont' = ("lato",6pt,Italic)
        /** Title & footnote fonts **/
        'TitleFont' = ("lato",10pt,Bold)
        'TitleFont2' = ("lato",10pt,Bold)
        /** Fixed-width fonts **/
        'FixedEmphasisFont' = ("Courier New, Courier",6pt,Italic)
        'FixedStrongFont' = ("Courier New, Courier",6pt,Bold)
        'FixedHeadingFont' = ("Courier New, Courier",6pt,Bold)
        'BatchFixedFont' = ("SAS Monospace, Courier New, Courier",6.6pt)
        'FixedFont' = ("Courier New, Courier",6pt);
      style body from body /
        /** Document page margins **/
        leftmargin=0.5in
        rightmargin=0.5in
        topmargin=0.5in
        bottommargin=0.5in
        protectspecialchars=off;
      /*
      style table from table /
        cellpadding = 1pt;
      */
      style systemtitle from systemtitle /
        /** Don't change this (enables RTF special characters) **/
        protectspecialchars=off;
      style systemfooter from systemfooter /
        /** Don't change this (enables RTF special characters) **/
        protectspecialchars=off;
      style data from data /
        /** Don't change this (enables RTF special characters) **/
        protectspecialchars=off;
  end;
  
  source styles.printer;
  source styles.rtf;
  source Styles.Rtf_lato_6pt;

run;

