# Let's call the library
library(data.table)
library(tidyverse)

# Let's set the working directory
setwd('/Users/analutzky/Desktop/SICSS_2002')

# Let's read our csv
Table_ANR_projets=fread('anr-dos-depuis-2010-projets-finances-20220504-projets.csv')
Discipline_code=fread('ANR_CES_list.csv')

# showing it excel-like
View(Table_ANR_projets)

# showing column names
colnames(Table_ANR_projets)

# Adding a CES column, extracting it from the ANR Decision code. 
# And then joining the CES description from ANR_CES_list.csv
Table_ANR_projets <- Table_ANR_projets %>% 
  mutate(CES = str_extract(Projet.Code_Decision_ANR, "CE[:digit:]{2}")) %>%
  left_join(Discipline_code, by = 'CES') 

# Adding an social_science column, value SSH designating the 4 disciplines that concern social sciences
Table_AAPG <- Table_ANR_projets %>%
  filter(!is.na(CES)) 
Table_AAPG <- Table_AAPG %>%
  mutate(social_science = case_when(str_detect(Table_AAPG$CES, "CE(26|27|28|41)") ~ "SSH",
                                    TRUE ~ "NO SSH"
    )) 

# Let's count the SHS and non SHS projects just to have an idea
SHS_count <- Table_AAPG %>% group_by(social_science) %>%
  count()

# Getting rid of spaces and accent in the Table_AAPG CES description variable
colnames(Table_AAPG)[12]<-"Comite_evaluation_scientifique"    

# Our Projet.Aide_alloue is character and has comas instead of dots, let's transform it into numeric
Table_AAPG$Projet.Aide_allouee <- as.numeric(gsub(",", ".",Table_AAPG$Projet.Aide_allouee))

# Now let's summarize the number of projects financed and amount of money given per year and per CES
# Let's also add a total of projects and amount of money given columns, in order to compute percentages in the dataviz
# Data.table style
Table_CES_per_year_data_table = Table_AAPG[,.(Aide_Projets=sum(Projet.Aide_allouee),Nb_Projets=length(unique(Projet.Code_Decision_ANR))),by=.(CES,Comite_evaluation_scientifique,AAP.Edition)]
Table_CES_per_year_data_table[,Aide_Projets_totale:=sum(Aide_Projets),by=AAP.Edition]
Table_CES_per_year_data_table[,Nb_Projets_total:=sum(Nb_Projets),by=AAP.Edition]

# R base style
Nb_projets=aggregate(Table_AAPG$Projet.Code_Decision_ANR, by=list(Table_AAPG$CES,Table_AAPG$AAP.Edition), FUN=length)
Aide_projets=aggregate(Table_AAPG$Projet.Aide_allouee, by=list(Table_AAPG$CES,Table_AAPG$AAP.Edition), FUN=sum)

# Tidyverse style
Table_per_year_tydiverse <-Table_AAPG %>%
group_by(AAP.Edition) %>%
summarize(aide_total_by_year = sum(Projet.Aide_allouee),
		  nombre_projets_by_year = n(),
		  .groups = "keep")

Table_CES_per_year_tydiverse <-Table_AAPG %>%
group_by(CES, Comite_evaluation_scientifique, AAP.Edition) %>%
summarize(aide_total = sum(Projet.Aide_allouee),
		  nombre_projets = n(),
		  .groups = "keep")%>%
			left_join(Table_per_year_tydiverse)

# Let's expot it in a csv
write.csv2(as.data.frame(Table_ANR_projets),file='Table_ANR_projets.csv',fileEncoding = "UTF8")
write.csv2(as.data.frame(Table_CES_per_year_tydiverse),file='Aide_projets_par_CES_et_annee.csv',fileEncoding = "UTF8")