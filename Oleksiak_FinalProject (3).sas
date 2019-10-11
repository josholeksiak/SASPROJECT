/* Auto-run file */
libname SPR18  '/home/joleksia0/STAT 3010 Spring 2018' ;

/* Generated Code (IMPORT) */
/* Source File: Oleksiak_OLINEData.xlsx */
/* Source Path: /home/joleksia0/STAT 3010 Spring 2018 */
/* Code generated on: 4/16/18, 9:10 AM */
/* Automatically generated code for excel table */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/joleksia0/STAT 3010 Spring 2018/Oleksiak_OLINEData.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

/* Putting Data Set into permanent file */
data SPR18.oline;
	set work.IMPORT;
	run;
	
/* Run Every Time */
data work.oline;
	set Spr18.oline;
	run;

Proc format;
	Value CAT_HLDFORMAT 	
		1=Low
		2=Medium
		3=High;
run;

Proc format;
	Value CAT_PENYARDSFORMAT 	
		1=Low
		2=Medium
		3=High;
run;

data work.olineCAT;
	set Spr18.olineCAT;
run;

data work.olineCAT_labels;
	set Spr18.olinecat_labels;
	run;

/* Making new categorical variables */
data work.olineCAT;
	set work.oline;
	if HLD_Pen<1 then CAT_HLD=1;
	else if 1<= HLD_Pen<2 then CAT_HLD=2;
	else if HLD_Pen>=2 then CAT_HLD=3;
run;

Proc format;
	Value CAT_HLDFORMAT 	
		1=Low
		2=Medium
		3=High;
run;

data work.olineCAT;
	set work.olineCAT;
	format CAT_HLD CAT_HLDFORMAT.;
run;
proc print data=work.olineCAT;
run;
data SPR18.olineCAT;
	set work.olineCAT;
run;

/* Second new categorical variable */
data work.olineCAT;
	set work.olineCAT;
	if Pen_Yards<10 then CAT_PENYARDS=1;
	else if 10<= Pen_Yards<25 then CAT_PENYARDS=2;
	else if Pen_Yards>=25 then CAT_PENYARDS=3;
run;

Proc format;
	Value CAT_PENYARDSFORMAT 	
		1=Low
		2=Medium
		3=High;
run;

data work.olineCAT;
	set work.olineCAT;
	format CAT_PENYARDS CAT_PENYARDSFORMAT.;
run;
proc print data=work.olineCAT;
run;
data SPR18.olineCAT;
	set work.olineCAT;
run;

/* Appendix Title */
data title_page;
text="APPENDIX II: Tables and Figures";
run; 
/* Making Labels of Data Better */
Proc format;
	Value $ ConfFORMAT
	"A"="AFC"
	"N"="NFC";
run;
Proc format;
	Value $ PositionFORMAT
	"C"="Center"
	"T"="Tackle"
	"G"="Guard";
run;
data work.olineCAT_labels;
	set work.olineCAT;
	label 	Conf="Conference"
			Position="Position"
			Pen="Penalties"
			Pen_Yards="Penalty Yards"
			Sacks_Allowed="Sacks Allowed"
			FST_Pen="False Start Penalties"
			HLD_Pen="Holding Penalties"
			CAT_HLD="Categorized Holding Penalties"
			CAT_PENYARDS="Categorized Penalty Yards";
	format Position PositionFORMAT.;
	format Conf ConfFORMAT.;
run;
proc print data=work.olineCAT_labels;
run;
data SPR18.olineCAT_labels;
	set work.olineCAT_labels;
run;
/* Make 100% stacked bar chart work later */
PROC FREQ DATA = work.olinecat_labels;
TABLES Position*CAT_HLD;  
ODS OUTPUT CrossTabFreqs = CT;
DATA CT2;
SET CT (DROP = TABLE _TYPE_ _TABLE_ MISSING);
IF NOT MISSING (ROWPERCENT); 
RUN;

/* Scatterplot time with a macro */
proc reg data=work.olinecat_labels;
   model Pen = Sacks_allowed;
   ods output ParameterEstimates=PE;
run;
proc print data=PE;
run;
data _null_;
   set PE;
   if _n_ = 1 then call symput('Int', put(estimate, BEST6.)); 
   else            call symput('Slope', put(estimate, BEST6.));
run;

proc reg data=work.olinecat_labels;
   ods output fitstatistics=fs ParameterEstimates=c;
   model Pen = sacks_allowed;
run;

data _null_;
   set fs;
   if _n_ = 1 then call symputx('R2'  , put(nvalue2, 4.2)   , 'G');
   if _n_ = 2 then call symputx('mean', put(nvalue1, best6.), 'G');
run;

/* Remember the appendix title */
Proc print data=title_page;
run; 
/* Making frequency tables, pie charts, and bar charts for all categorical variables */
/* First, we do it for the categorized holding penalties*/
title1 'Table 1: Frequency Table for';
title2 'Categorized Holding Penalties (n=267)';
proc freq data=olineCAT_labels;
	tables CAT_HLD;
run;
PROC GCHART DATA = work.olineCAT_labels;
  PIE CAT_HLD / DISCRETE 
  VALUE = INSIDE PERCENT=INSIDE  SLICE=OUTSIDE;
  TITLE1 Figure 1:  Pie Chart of Categorized Holding Penalties (n=267);
RUN;

PROC SGPLOT DATA = work.olineCAT_labels;
  vbar CAT_HLD / datalabel stat=FREQ;
  TITLE1 ‘Figure 2:  Bar Chart of Categorized Holding Penalties (n=267)’;
RUN;
/* Now, we do it for the conference*/
title1 'Table 2: Frequency Table';
title2 'for Conference (n=267)';
proc freq data=olineCAT_labels;
	tables Conf;
run;
PROC GCHART DATA = work.olineCAT_labels;
  PIE Conf / DISCRETE 
  VALUE = INSIDE PERCENT=INSIDE  SLICE=OUTSIDE;
  TITLE1 Figure 3:  Pie Chart of Conference (n=267);
RUN;

PROC SGPLOT DATA = work.olineCAT_labels;
  VBAR Conf / datalabel stat=FREQ;  
  TITLE1 ‘Figure 4:  Bar Chart of Conference (n=267)’;
RUN;
/* Now, we do it for the position*/
title1 'Table 3: Frequency Table';
title2 'for Position (n=267)';
proc freq data=olineCAT_labels;
	tables Position;
run;
PROC GCHART DATA = work.olineCAT_labels;
  PIE Position / DISCRETE 
  VALUE = INSIDE PERCENT=INSIDE  SLICE=OUTSIDE;
  TITLE1 Figure 5:  Pie Chart of Position (n=267);
RUN;

PROC SGPLOT DATA = work.olineCAT_labels;
  VBAR Position / datalabel stat=FREQ;  
  TITLE1 ‘Figure 6:  Bar Chart of Position (n=267)’;
RUN;
/* Descriptive Statistics and histogram and boxplot for sacks allowed */
PROC SGPLOT DATA = work.olinecat_labels;
  HISTOGRAM Sacks_Allowed / datalabel=percent;
  TITLE1 ‘Figure 7:  Histogram of Sacks Allowed’;
RUN;
PROC SGPLOT DATA = work.olinecat_labels;
  VBOX Sacks_Allowed / datalabel;
  TITLE1 ‘Figure 8:  Box Plot of Sacks Allowed’;
RUN;
title1 'Table 4: Descriptive Statistics for';
title2 'Sacks Allowed(n=267)';
Proc means data=work.olineCAT_labels maxdec=2 mean stddev min Q1 median Q3 max Qrange range skewness;
Var Sacks_Allowed;
run;
/* Descriptive Statistics and histogram and boxplot for penalties */
PROC SGPLOT DATA = work.olinecat_labels;
  HISTOGRAM Pen / datalabel=percent;
  TITLE1 ‘Figure 9:  Histogram of Penalties’;
RUN;
PROC SGPLOT DATA = work.olinecat_labels;
  VBOX Pen / datalabel;
  TITLE1 ‘Figure 10:  Box Plot of Penalties’;
RUN;
title1 'Table 5: Descriptive Statistics';
title2 'for Penalties(n=267)';
Proc means data=work.olineCAT_labels maxdec=2 mean stddev min Q1 median Q3 max Qrange range skewness;
Var Pen;
run;
/* Quantitative vs. Quantitative */
proc sgplot data=work.olineCat_labels noautolegend;
   title "Figure 11: Does Sacks Allowed Predict Penalties?";
   reg y=Pen x=Sacks_allowed;
   inset "R = 0.31"  
   "R(*ESC*){sup '2'} = &r2"
   "Intercept = &Int" "Slope = &Slope" / 
         border title="Parameter Estimates" position=topleft;
run;
/* Categorical and Quantitative */
/* Descriptive Stats */
title1 'Table 6: Descriptive Statistics of';
title2 'Sacks Allowed Stratified by Conference';
PROC MEANS DATA = work.olinecat_labels;
CLASS conf;
VAR sacks_allowed;
RUN;
/* Confidence Intervals */
title1 'Table 7: Stratified Confidence Intervals';
title2 'of Sacks Allowed by Conference';
proc means data=work.olinecat_labels mean LCLM UCLM maxdec=2;
var sacks_allowed;
class conf;
run;
/* Boxplots */
PROC SGPLOT DATA = work.olinecat_labels;
TITLE 'Figure 12: Side by Side Boxplots of Sacks Allowed by Conference';
HBOX sacks_allowed / CATEGORY=Conf datalabel;
XAXIS LABEL = 'Sacks Allowed' MIN=-2 MAX=12;
RUN;
/* Histograms */
PROC SORT DATA=work.olineCat_labels;
BY Conf;
RUN;
TITLE "Figure 13: Histogram of Sacks Allowed for the Offensive Linemen";
PROC SGPLOT DATA=work.olinecat_labels;
Histogram sacks_allowed/ binstart = 1.5 binwidth = 3 scale=count datalabel;
BY CONF;
XAXIS LABEL = "Sacks Allowed" integer;
RUN;
/* Categorical vs Categorical */
/* First we do contigency tables */
title1 'Table 8: Contingency Table of Position';
title2 'by Categorized Holding Penalties';
Proc Freq data=work.olinecat_labels;
tables Position*CAT_HLD;
run;
/* Then we do 100% stacked bar chart */
PROC SGPLOT DATA = CT2;
TITLE 'Figure 14: 100% Stacked Bar Chart of Position by Categorized Holding Penalties';
VBAR Position / GROUP = Cat_HLD RESPONSE=ROWPERCENT SEGLABEL;
YAXIS LABEL = 'Percent within Position' ;
RUN;
/* Proc Export data */
proc export data=work.olinecat_labels dbms=xls
outfile="C:Users\Josh\Desktop\Oleksiak_Oline_Output.xls";
run;