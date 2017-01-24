#predict_error

predictions = function(fit,train_df){
  train_p=predict(fit,newdata=train_df,type="vector")
  # replace to match -1 and 1 with training label
  train_p=replace(train_p, train_p==1, -1)
  train_p=replace(train_p, train_p==2, 1)
  return(train_p)
}

train_error_rate = function(train_p,train_df){
  train_success=sum(train_p==train_df$y)/length(train_p)
  return(1-train_success) # train success rate
}

test_error_rate = function(fit,test_df){
  p=predict(fit,newdata=test_df,type="vector")
  # codes 0s as 2s for some reason
  # run this in order!
  p=replace(p, p==1, -1)
  p=replace(p, p==2, 1)
  #head(p)
  #head(test_df$y)
  test_success = sum(p==test_df$y)/length(p) # test success!
  return(1-test_success) # test error rate matches ESL
}
