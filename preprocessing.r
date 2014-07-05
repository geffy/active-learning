load_and_preprocess_raws <- function(N=10000, 
                                     #need_to_refresh=F, 
                                     data_file="./data/mnist_pca20.rObj",
                                     randomize=F ){
  #if (need_to_refresh){
  #  load("./data//mnist.rObj")
  #  cat("Calc PCA... \n")
  #  tmp <- princomp(train$x)
  #  train$x <- tmp$scores[, 1:20]
  #} else {
  #  load("./data/mnist_pca20.rObj")
  #}
  
  # [!] Needed to be in train{x,y}
  load(data_file)
  
  # generate point IDs
  train$ids <- 1:nrow(train$x)
  
  cat("Data loaded! dim=[", dim(train$x), '], ')
  if (randomize==T){
    ind <- sample(1:nrow(train$x), N, replace=F)
    cat("[sampled points] \n")
  } else {
    ind <- 1:N
    cat("[fixed points] \n ")
  }
  dataset <- list()
  dataset$x <- train$x[ind, ]
  dataset$y <- train$y[ind]
  dataset$ids <- train$ids[ind]
  dataset$density <- train$density[ind]
  return(dataset)
} 


split_to_train <- function(ds, b){
  train <- list()
  start <- b[1]+1
  end <- b[1]+b[2]
  ind <- start:end
  train$x <- ds$x[ind, ]
  train$y <- ds$y[ind]
  train$ids <- ds$ids[ind]
  return(train)
}


split_to_pool <- function(ds, b){
  pool <- list()
  start <- b[1] + b[2] + 1
  end <- nrow(ds$x)
  ind <- start:end
  pool$x <- ds$x[ind, ]
  pool$y <- ds$y[ind]
  pool$ids <- ds$ids[ind]
  pool$density <- ds$density[ind]
  return(pool)
}


split_to_test <- function(ds, b){
  test <- list()
  start <- 1
  end <- b[1]
  ind <- start:end
  test$x <- ds$x[ind, ]
  test$y <- ds$y[ind]
  test$ids <- ds$ids[ind]
  return(test)
}