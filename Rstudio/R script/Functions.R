# this is the list of functions 

library(dplyr)
library(stringr)



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
  
  df<- df%>% dplyr::filter(PARAMCD=="C64849B",VISITNUM==10)
  return(df)
}


preprocessing_ex2<-function(df){
  
  df<- df%>% dplyr::filter(PARAMCD=="C64849B",ANL01FL=="Y")
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

library(readxl)






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




