# this is the list of functions 

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




#Main functions 


ADSL_processed<-check_weight(ADSL)
ADSL_processed<-check_height(ADSL_processed)
ADLB_ex1<-preprocessing_ex1(ADLB)
ADLB_ex2<-preprocessing_ex2(ADLB)
ADLB_processed<-remove_duplicate(ADLB_ex1)




#df1<-df1 %>% mutate(ANL01FL=tolower(ANL01FL))





