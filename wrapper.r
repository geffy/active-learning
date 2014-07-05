source("./preprocessing.r")
source("./config.r")
source("./core.r")

library(ggplot2)

# Function-wrapper for in-place full processing.
# "label" option used only for output labeling 
full_processing <- function(cfg, label){
  
  # all point in (data.x, data.y) structure, loaded by
  dataset <- load_and_preprocess_raws(cfg$data$all_points, cfg$data$file, cfg$randomize)

  # init POOL/TRAIN
  borders_of_sets <- c(cfg$data$test_size, cfg$data$init_train_size)
  train <- split_to_train(dataset, borders_of_sets)
  pool <- split_to_pool(dataset, borders_of_sets)
  
  # init TEST - by splitting or by load external fixed set
  cat("----[", cfg$data$test_file, "]----\n" )
  if (cfg$data$test_file == ''){
    test <- split_to_test(dataset, borders_of_sets)
  } else {
    # object should be test{x,y} 
    load(cfg$data$test_file)
    cat("Loaded external test-set [", cfg$data$test_file, "]\n" )
  }
  
  # init density-weighted part
  # see function "core::similarities" for detail about used kernel\metric
  cat("----[ init density for pool]----\n" )
  if (cfg$density_weighted == 'calc') {
    cat("Start to calculate density-weight\n", paste0(rep("-", 50), collapse=''), "\n")
    pool$density <- array(0, nrow(pool$x))
    progress <- 0
    for (i in 1:nrow(pool$x)){
      #coord_diffs <- apply(pool$x, MARGIN=1, '-', pool$x[i,])
      coord_diffs <- t(pool$x) - matrix(as.numeric(pool$x[i,]), ncol(pool$x), nrow(pool$x))
      pool$density[i] <- sum(apply(coord_diffs, 2, similarities)) / nrow(pool$x)
      if (floor(i/nrow(pool$x)*50) > progress){
        cat('.')
        progress <- progress + 1
      }
    }
    cat('!\n')
  } 
  if (cfg$density_weighted == 'ones') {
    cat("Initialized by ones\n")
    pool$density <- array(1, nrow(pool$x))
  }
  if (cfg$density_weighted == 'read') {
    cat("Readed from extend file, skip calculating\n")
  }
  
  
  out <- list()
  out$train_ids <- append(out$train_ids, list(train$ids))
  rm(dataset)
  print("Init complete!")
  
  #[main loop]
  accuracy <- 0
  train_points <- 0
  
  # SWITCHING BETWEEN POOL AND LIMIT MODE - MANUALLY!
  
  
  while (nrow(pool$x) >= cfg$data$points_per_step){ # [pool  mode]
  #while (nrow(train$x) <= cfg$data$limit){         # [limit mode]
  
    # learn model
    model <- retrain_model(train$x, train$y, cfg)
    # and check quality
    train_points <- append(train_points, nrow(train$x))
    cur_accuracy <- check_model_quality(model, test, cfg)
    accuracy <- append(accuracy, cur_accuracy)
    
    # get probabilities
    probs <- get_probabilities(model, pool$x, cfg)
    
    # select by criteria (get scores / found best points)
    scores <- 1 + apply(probs, 1, function(x) {criteria(x, cfg$criteria_type)})
    scores <- scores * pool$density
    target_ind <- sort_id_by_scores(scores)[(1:cfg$data$points_per_step), 1]
    
    # rebuild train/pool
    train <- rebuild_set(train, pool, target_ind, "train")
    pool <- rebuild_set(train, pool, target_ind, "pool")
    out$train_ids <- append(out$train_ids, list(train$ids))
    
    cat("[", cfg$model$type, "] trainsize:", train_points[length(train_points)], 
        "\t accuracy:", cur_accuracy, "\n")
    }
  
  # [last measure]
  train_points <- append(train_points, nrow(train$x))
  model <- retrain_model(train$x, train$y, cfg)
  cur_accuracy <- check_model_quality(model, test, cfg)
  accuracy <- append(accuracy, cur_accuracy)
  cat("[", cfg$model$type, "] trainsize:", train_points[length(train_points)], 
      "\t accuracy:", cur_accuracy, "\n")
  ##
  
  res <- data.frame(train_points)
  res <- cbind(res, accuracy)
  res <- cbind(res, cfg$criteria_type)
  res <- cbind(res, cfg$model$type)
  res <- cbind(res, label)
  names(res) <- c("train_points", 'accuracy', 'criteria', 'model', 'tag')
  out$result <- res
  return(out)
}