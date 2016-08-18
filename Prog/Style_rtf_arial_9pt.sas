/**************************************************************************
 Program:  Style_rtf_arial_9pt.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/15/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create ODS style Rtf_arial_9pt.

 Modifications:
  08/07/14 PAT Updated for SAS1 server.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;

** New style for RTF output **;

proc template;
  define style Styles.Rtf_arial_9pt;
    parent=styles.rtf;
       style Table from Output /
             /** Cell background color **/
             Background=_undef_
             /** Lines between columns and rows **/
             Rules=groups
             /** Lines around table **/
             frame=hsides;
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
        'docFont' = ("Arial",9pt)
        /** Heading fonts **/
        'headingEmphasisFont' = ("Arial",9pt,Bold Italic)
        'headingFont' = ("Arial",9pt,Bold)
        'StrongFont' = ("Arial",9pt,Bold)
        'EmphasisFont' = ("Arial",9pt,Italic)
        /** Title & footnote fonts **/
        'TitleFont' = ("Arial",11pt,Bold)
        'TitleFont2' = ("Arial",11pt,Bold)
        /** Fixed-width fonts **/
        'FixedEmphasisFont' = ("Courier New, Courier",9pt,Italic)
        'FixedStrongFont' = ("Courier New, Courier",9pt,Bold)
        'FixedHeadingFont' = ("Courier New, Courier",9pt,Bold)
        'BatchFixedFont' = ("SAS Monospace, Courier New, Courier",6.7pt)
        'FixedFont' = ("Courier New, Courier",9pt);
      style body from body /
        /** Document page margins **/
        leftmargin=0.75in
        rightmargin=0.5in
        topmargin=0.75in
        bottommargin=0.5in
        protectspecialchars=off;
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
  source Styles.Rtf_arial_9pt;

run;

