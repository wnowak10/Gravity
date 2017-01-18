#make_boost_data

#boosting from ESL p. 339
# create train data. n = # obs= user input

create_train_data = function(n){
  # create features
  for(i in 1:10){
    assign(paste("x", i, sep = ""), rnorm(n))    
  }
  
  # create label vay (y)
  y_lim=qchisq(.5,10)
  y=ifelse(x1^2+x2^2+x3^2
           +x4^2+x5^2+x6^2
           +x7^2+x8^2
           +x9^2+x10^2>y_lim,1,-1)
  
  df = data.frame(x1,x2,x3,x4,
                  x5,x6,x7,x8,
                  x9,x10,y)
  df$y=as.factor(df$y)
  return(df)
  # sum(y==1) # should be around 1000 according to ESL.
  # it is
}
#train_df=create_train_data(2000)

# create test data
# same as train 
create_test_data = function(n_test){
  # create features
  for(i in 1:10){
    assign(paste("x", i, sep = ""), rnorm(n_test))    
  }
  
  # create label var (y)
  y_lim=qchisq(.5,10)
  y=ifelse(x1^2+x2^2+x3^2
           +x4^2+x5^2+x6^2
           +x7^2+x8^2
           +x9^2+x10^2>y_lim,1,-1)
  
  df = data.frame(x1,x2,x3,x4,
                  x5,x6,x7,x8,
                  x9,x10,y)
  df$y=as.factor(df$y)
  return(df)
  # sum(y==1) # should be around 1000 according to ESL.
  # it is
}

#test_df=create_test_data(10000)

