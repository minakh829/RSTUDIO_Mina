# this is the list of functions 

library(dplyr)
library(stringr)
library(ggplot2)
library(readxl)

check_weight<-function(df){
  
  df[["WGTBL"]]= ifelse(df[["WGTBLU"]]=="lb",df[["WGTBL"]]*0.45,df[["WGTBL"]])
  df[["WGTBLU"]]= ifelse(df[["WGTBLU"]]=="lb","kg","kg")
  return(df)
}

check_height<-function(df){
  
  df[["HGTBL"]]= ifelse(df[["HGTBLU"]]=="m" & df[["HGTBL"]]<2.5 ,df[["HGTBL"]],df[["HGTBL"]]*0.01)
return(df)
 
}


preprocessing_ex1<-function(df){
  
  df<- df%>% dplyr::filter(PARAMCD=="C64849B",VISITNUM==10, FASFL=="Y")
  return(df)
}


preprocessing_ex2<-function(df){
  
  df<- df%>% dplyr::filter(PARAMCD=="C64849B",ANL01FL=="Y", FASFL=="Y")
  return(df)
}

remove_duplicate<-function(df,fL=TRUE){
  
  df<-df[which(duplicated(df$SUBJID,fromLast = fL)==FALSE),]
  return(df)
}

add_weeknumber<-function(df){
  
  df<- df %>% dplyr::mutate(WeekNumber=as.numeric(str_split_fixed(str_split_fixed(df$AVISIT, "[(Week]", 6)[,6], "[)]", 2)[,1]))
  return(df)
}



#Main functions 








#Loading the data
ADSL<- read_excel("C://Users//Mina/Documents/GitHub//RSTUDIO_Mina//Rstudio//Data//data.xlsx", sheet = "ADSL")
ADLB<- read_excel("C://Users//Mina/Documents/GitHub//RSTUDIO_Mina//Rstudio//Data//data.xlsx", sheet = "ADLB")






ADSL_processed<-check_weight(ADSL)
ADSL_processed<-check_height(ADSL_processed)
ADLB_ex1<-preprocessing_ex1(ADLB)
ADLB_ex2<-preprocessing_ex2(ADLB)
ADLB_ex1<-remove_duplicate(ADLB_ex1)
dataexe2<-add_weeknumber(ADLB_ex2)
dataexe1<- ADSL_processed%>% left_join(ADLB_ex1,by="SUBJID")


# df1<-df1 %>% mutate(ANL01FL=tolower(ANL01FL))


#Ex1

y<-matrix(dataexe1 %>% select(AGE,WGTBL,HGTBL,DIABDUR,AVAL)%>% drop_na() %>% summarise_all(list(mean=mean,max=max,std=sd,min=min)),nrow=5)
rownames(y)=c('age','weight','Height','DIABDUR','HbA1c ')
colnames(y)=c('mean','max','std','min')
Number=colSums(!is.na(dataexe1))[c("AGE","WGTBL","HGTBL","DIABDUR","AVAL")]
Total_table<- cbind(y,Number)



#Ex2

TRTP_by <- dataexe2 %>%
  group_by(WeekNumber,TRTP) %>%
  summarize(meanAVAL = mean(AVAL),
            )
ggplot2::ggplot(TRTP_by,aes(WeekNumber,meanAVAL,color=TRTP))+geom_line()


