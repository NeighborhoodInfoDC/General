/**************************************************************************
 Program:  TR10_to_StdGeos.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  6/6/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  This program appends NIDC standard geographies to geo2010.

 Modifications:
**************************************************************************/

%macro tr10_to_stdgeos( 
  in_ds=, 
  out_ds=,
  keepgeos=anc2002 anc2012 Cluster_tr2000 Cluster2017 psa2004 psa2012 VoterPre2012
		   ward2002 ward2012 Bridgepk stantoncommons city /* Keep all by default */
);


%macro tr_geo_corr (geo,wtname);

proc sort data = general.Wt_tr10_&wtname. out = &geo._all; by geo2010 popwt; run;

data &geo._used &geo._notused;
	set &geo._all;
	by geo2010 popwt;
	if last.Geo2010 then output &geo._used;
	else output &geo._notused;
run;

proc sort data = &geo._used (keep = geo2010 &geo.) out = &geo.; by geo2010; run;

proc datasets lib=work nolist;
 delete &geo._all &geo._used &geo._notused;
run;


%mend tr_geo_corr;
%tr_geo_corr (anc2002,anc02);
%tr_geo_corr (anc2012,anc12);
%tr_geo_corr (Cluster_tr2000,cltr00);
%tr_geo_corr (Cluster2017,cl17);
%tr_geo_corr (psa2004,psa04);
%tr_geo_corr (psa2012,psa12);
%tr_geo_corr (VoterPre2012,vp12);
%tr_geo_corr (ward2002,ward02);
%tr_geo_corr (ward2012,ward12);
%tr_geo_corr (Bridgepk,bpk);
%tr_geo_corr (stantoncommons,stanc);
%tr_geo_corr (city,city);


data Tr10_stdgeos;
	merge &keepgeos.;
	by geo2010;
	keep geo2010 &keepgeos.;
run;


proc sort data = Tr10_stdgeos; by geo2010; run;
proc sort data = &in_ds.; by geo2010; run;

data &out_ds.;
	merge &in_ds. (in=a) Tr10_stdgeos;
	by geo2010;
	if a;
run;

%mend tr10_to_stdgeos;


/* End of macro defintion */
