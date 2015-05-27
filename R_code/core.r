# File with main general functions:
# - retrain_model
# - get_probabilities
# - check_model_quality
# - criteria
# - sort_id_by_scores
# - rebuild_set
# Strongly depends from "cfg" structure. See "config.r" for details.


library(randomForest)
library(glmnet)
library(e1071)
library(gbm)
library(doMC)

retrain_model <- function(x, y, cfg){
  # put your number of cores here
  N_CORES = 3
  
  if (cfg$model$type == 'rf'){
    registerDoMC(cores=N_CORES)
    
    #model <- randomForest(x, as.factor(y), ntree=cfg$model$ntrees, norm.votes=T)
    model <- foreach(ntree=rep(round(cfg$model$ntrees/N_CORES), N_CORES), .combine=combine, .multicombine=TRUE,
                          .packages='randomForest') %dopar% {
                            randomForest(x, as.factor(y), ntrees = ntree, importance=F, 
                                        #mtry=cfg$model$mtry,             # uncomment if want to tune it
                                        #nodesize = cfg$model$nodesize,
                                        maxnodes = cfg$model$maxnodes,
                                        norm.votes=T)
                          }
  }
  
   
  if (cfg$model$type == 'glm'){
    registerDoMC(cores=N_CORES)
    model <- cv.glmnet(data.matrix(x), as.factor(y), family='multinomial', 
                      nlambda=cfg$model$nlambda, 
                      nfolds=cfg$model$nfolds, parallel=T, alpha=1)
  }
  
  if (cfg$model$type == 'gbm'){
    # not tested enough
    registerDoMC(cores=N_CORES)
    model <- gbm(as.factor(y) ~ ., data=data.frame(x), distribution='multinomial', 
                interaction.depth = cfg$model$int_depth,
                n.trees = cfg$model$ntree_learn, verbose=F, n.cores=3)
  }
  
  if (cfg$model$type == 'svm'){
    model <- svm(x, as.factor(y), type='C-classification', probability=T)
  }
  
  return(model)
}


get_probabilities <- function(model, x, cfg){
  if (cfg$model$type == 'rf') {
    prob <- predict(model, x, "prob")
  }
  
  if (cfg$model$type == 'glm') {
    prob <- predict(model, data.matrix(x), s = model$lambda.min, type='response')
    prob <- prob[,,1]
  }
  
  if (cfg$model$type == 'gbm') {
    prob <- predict(model, data.frame(x), type='response', n.trees=cfg$model$ntree_predict)
  }
  
  if (cfg$model$type == 'svm') {
    prob <- predict(model, x, probability=T)
    prob<- attr(prob, 'probabilities')
  }
  
  return(prob)
}


check_model_quality <- function(model, test, cfg){
  if (cfg$model$type =='rf') {
    pred <- predict(model, test$x)
    res <- sum(pred == test$y) / length(test$y)
  }
  
  
  if (cfg$model$type == 'glm') {
    pred <- as.numeric(predict(model, data.matrix(test$x), s=model$lambda.min, "class"))
    res <- sum(pred == test$y) / length(test$y)
  }
  
  if (cfg$model$type =='gbm') {
    prob <- predict(model, data.frame(test$x), type='response', cfg$model$ntree_predict)
    pred <- apply(prob, 1, function(x) {return(tail(which.max(x),1) - 1)})
    res <- sum(pred == test$y) / length(test$y)
  }
  
  if (cfg$model$type == 'svm') {
    pred <- predict(model, test$x)
    res <- sum(pred == as.factor(test$y)) / length(test$y)
  }
  return(res)
}


criteria <- function(p, type="entropy"){
  if (type=="entropy") {
    entropy <--p*log(p)
    entropy[is.nan(entropy)] <- 0
    res <- sum(entropy)
  }
  if (type=="margin"){
    p <- sort(p, decreasing=T)
    res <- -(p[1] - p[2])
  }
  if (type=="minmax"){
    res <- -max(p)
  }
  if (type=="random"){
    res <- rnorm(1)
  }
  
    
  return(res)
}


sort_id_by_scores <- function(score){
  ind <- 1:length(score)
  ans <- data.frame(ind, score)
  ans <- ans[with(ans, order(-score)),]
  return(ans)
}


rebuild_set <- function(train, pool, ind, type){
  
  if (type=="train"){
    train$x <- rbind(train$x, pool$x[ind, ])
    train$y <- c(train$y, pool$y[ind])
    train$ids <- c(train$ids, pool$ids[ind])
    res <- train
  }
  
  if (type=="pool"){
    pool$x <- pool$x[-ind,]
    pool$y <- pool$y[-ind]
    pool$ids <- pool$ids[-ind]
    pool$density <- pool$density[-ind]
    res <- pool
  }
  
  return(res)
}

# used only in calculating density-weighting
similarities <- function(x, d=3){
  return(exp(-sqrt(sum(x*x))/d))
}