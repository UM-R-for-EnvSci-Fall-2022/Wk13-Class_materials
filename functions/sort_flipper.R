sort_flipper <- function(data = data){
  
  data$flipper_group <- NA
  
  for(i in 1:length(data$flipper_length_mm)){
    
    data$flipper_group[i] <- if(is.na(data$flipper_length_mm[i])){NA}
    else if(data$flipper_length_mm[i] <= 190){"Short"}
    else if(190 < data$flipper_length_mm[i] & data$flipper_length_mm[i] <= 210){"Medium"}
    else{"Long"}
  }
  
  print(data)
  
}