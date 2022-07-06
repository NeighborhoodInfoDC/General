/**************************************************************************
 Program:  VoterPre2012.sas
 Library:  General
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  07/06/2022
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Voting Precincts (2012)

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;

data voterpre2012 ;

  input voterpre2012 $3.;
  
  voterpre2012_n = voterpre2012 + 0;
  voterpre2012_c = put(voterpre2012_n,3.);
  voterpre2012_name = 'Voting Precinct ' || compress( voterpre2012_c );

  drop voterpre2012_n voterpre2012_c;

  
  label 
    voterpre2012 = 'Voting Precinct (2012)'
    voterpre2012_name = 'Voting Precinct (2012), name'
;

datalines;
001
002
003
004
005
006
007
008
009
010
011
012
013
014
015
016
017
018
019
020
021
022
023
024
025
026
027
028
029
030
031
032
033
034
035
036
037
038
039
040
041
042
043
044
045
046
047
048
049
050
051
052
053
054
055
056
057
058
059
060
061
062
063
064
065
066
067
068
069
070
071
072
073
074
075
076
077
078
079
080
081
082
083
084
085
086
087
088
089
090
091
092
093
094
095
096
097
098
099
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
143
144
;
  
run;


%Finalize_data_set(
    data=voterpre2012,
    out=voterpre2012,
    outlib=general,
    label="List of Voting Precincts (2012)",
    sortby=voterpre2012,
    /** Metadata parameters **/
    revisions=New file.,
    /** File info parameters **/
    printobs=8
  )

** Create formats **;

%Data_to_format(
  FmtLib=General,
  FmtName=$vote12a,
  Desc="Voting Precinct (2012)",
  Data=voterpre2012,
  Value=voterpre2012,
  Label=voterpre2012_name,
  OtherLabel=,
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )

** Validation format - returns tract number if valid, blank otherwise **;

%Data_to_format(
  FmtLib=General,
  FmtName=$vote12v,
  Desc="Voting Precinct (2012), validation",
  Data=voterpre2012,
  Value=voterpre2012,
  Label=voterpre2012,
  OtherLabel='',
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=Y
  )



** Add $ward22a format to data set **;

proc datasets library=General nolist memtype=(data);
  modify voterpre2012;
    format voterpre2012 $vote12a.;
quit;

