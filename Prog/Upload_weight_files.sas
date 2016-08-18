/**************************************************************************
 Program:  Upload_weight_files.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/05/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload weighting files to Alpha and register metadata.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;


rsubmit;

/** Macro Upload_geo - Start Definition **/

%macro Upload_geo( data=, revisions=New file. );

  proc upload status=no
  data=General.&data 
  out=General.&data (compress=no);

  run;
  
  x "purge [DCData.General.data]&data..*";
  
  run;
  
  %Dc_update_meta_file(
    ds_lib=General,
    ds_name=&data,
    creator_process=&data..sas,
    restrictions=None,
    revisions=%str(&revisions)
  )
  
  run;

%mend Upload_geo;

/** End Macro Definition **/


%Upload_geo( data=wt_bg00_anc02, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_city, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_cl00, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_cltr00, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_eor, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_psa04, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_ward02, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg00_zip, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_bg10_anc02 )
%Upload_geo( data=wt_bg10_anc12 )
%Upload_geo( data=wt_bg10_city )
%Upload_geo( data=wt_bg10_cl00 )
%Upload_geo( data=wt_bg10_cltr00 )
%Upload_geo( data=wt_bg10_eor )
%Upload_geo( data=wt_bg10_psa04 )
%Upload_geo( data=wt_bg10_psa12 )
%Upload_geo( data=wt_bg10_ward02 )
%Upload_geo( data=wt_bg10_ward12 )
%Upload_geo( data=wt_bg10_zip )


/***** PREVIOUS UPLOADS **************************
%Upload_geo( data=wt_bg10_vp12 )
%Upload_geo( data=wt_bg00_vp12 )
%Upload_geo( data=wt_tr00_vp12 )
%Upload_geo( data=wt_tr10_vp12 )
%Upload_geo( data=wt_bg00_ward12, revisions=%str(Corrected var label for Ward2012.) )
%Upload_geo( data=wt_tr00_anc02, revisions=%str(File update.) )
%Upload_geo( data=wt_tr00_anc12, revisions=%str(File update.) )
%Upload_geo( data=wt_tr00_city, revisions=%str(File update.) )
%Upload_geo( data=wt_tr00_cl00, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_tr00_cltr00, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_tr00_eor, revisions=%str(File update.) )
%Upload_geo( data=wt_tr00_psa04, revisions=%str(File update.) )
%Upload_geo( data=wt_tr00_psa12, revisions=%str(File update.) )
%Upload_geo( data=wt_tr00_tr10, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_tr00_ward02, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_tr00_ward12, revisions=%str(Corrected var label for Ward2012.) )
%Upload_geo( data=wt_tr00_zip, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_anc02, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_anc12, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_city, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_cl00, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_cltr00, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_eor, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_psa04, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_psa12, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_tr00, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_tr10_ward02, revisions=%str(File update.) )
%Upload_geo( data=wt_tr10_ward12, revisions=%str(Corrected var label for Ward2012.) )
%Upload_geo( data=wt_tr10_zip, revisions=%str(File update.) )

%Upload_geo( data=wt_tr10_anc02 )
%Upload_geo( data=wt_tr10_anc12 )
%Upload_geo( data=wt_tr10_city )
%Upload_geo( data=wt_tr10_cl00 )
%Upload_geo( data=wt_tr10_cltr00 )
%Upload_geo( data=wt_tr10_eor )
%Upload_geo( data=wt_tr10_psa04 )
%Upload_geo( data=wt_tr10_psa12 )
%Upload_geo( data=wt_tr10_ward02, revisions=%str(Use new %Calc_weights_from_blocks macro, add Popwt_prop.) )
%Upload_geo( data=wt_tr10_ward12 )
%Upload_geo( data=wt_tr10_zip )

%Upload_geo( data=wt_bg00_anc12 )
%Upload_geo( data=wt_bg00_psa12 )
%Upload_geo( data=wt_bg00_ward12 )
%Upload_geo( data=wt_tr00_anc12 )
%Upload_geo( data=wt_tr00_psa12 )
%Upload_geo( data=wt_tr00_ward12 )

** Delete draft 2012 ward weight files **;

%Delete_metadata_file( 
  ds_lib=General,
  ds_name=wt_tr00_ward12b,
  meta_lib=metadat,
  meta_pre=meta,
  update_notify=ptatian@urban.org
)

%Delete_metadata_file( 
  ds_lib=General,
  ds_name=wt_tr10_ward12b,
  meta_lib=metadat,
  meta_pre=meta,
  update_notify=ptatian@urban.org
)

%Upload_geo( data=wt_tr00_ward12b, revisions=%str(Corrected definitions of wards 1, 3, 4.) )

%Upload_geo( data=wt_tr00_tr10 )
%Upload_geo( data=wt_tr10_tr00 )

%Upload_geo( data=wt_bg00_bg10 )
%Upload_geo( data=wt_bg10_bg00 )

%Upload_geo( data=wt_tr00_ward12b, revisions=%str(Corrected definitions of wards 1, 3, 4.) )
%Upload_geo( data=wt_tr10_ward12b, revisions=%str(Corrected definitions of wards 1, 3, 4.) )

%Upload_geo( data=wt_tr10_ward02 )

%Upload_geo( data=wt_taz00_cltr00 )
%Upload_geo( data=wt_taz00_ward02 )

%Upload_geo( data=wt_tr70_tr00 )
%Upload_geo( data=wt_tr80_tr00 )
%Upload_geo( data=wt_tr90_tr00 )

%Upload_geo( data=wt_tr00_hmt05 )

%Upload_geo( data=wt_tr00_city, revisions=Corrected missing weight. )
%Upload_geo( data=wt_tr00_ward02, revisions=Corrected missing weight. )
%Upload_geo( data=wt_tr00_cltr00, revisions=Corrected missing weight. )
%Upload_geo( data=wt_tr00_psa04, revisions=Corrected missing weight. )

%Upload_geo( data=wt_tr00_anc02 )
%Upload_geo( data=wt_tr00_cl00 )
%Upload_geo( data=wt_tr00_cnb03 )
%Upload_geo( data=wt_tr00_cta03 )
%Upload_geo( data=wt_tr00_eor )
%Upload_geo( data=wt_tr00_zip )
********************************************/

run;

endrsubmit;

signoff;

