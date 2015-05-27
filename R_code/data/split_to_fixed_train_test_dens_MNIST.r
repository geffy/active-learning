# see "slpit_to_fixed_train_dens_covtype" for comments.
# Structure is exactly the same

source("core.r")
load("./data/mnist_pca20.rObj")
# TEST
test <- list()
test$x <- train$x[10001:15000, ]
test$y <- train$y[10001:15000]
test$n <- 5000
save(test, file="./data//mnist_test_5k.rObj")
cat("Test saves\n")

# TRAIN
train$x <- train$x[1:10000, ]
train$y <- train$y[1:10000]
train$n <- 10000

# calc density
# cat("Start to calculate density-weight\n", paste0(rep("-", 50), collapse=''), "\n")
# train$density <- array(0, nrow(train$x))
# progress <- 0
# for (i in 1:nrow(train$x)){
#   coord_diffs <- t(train$x) - matrix(as.numeric(train$x[i,]), ncol(train$x), nrow(train$x))
#   train$density[i] <- sum(apply(coord_diffs, 2, function(x) {sqrt(sum(x*x))})) / nrow(train$x)
#   
#   if (floor(i/nrow(train$x)*50) > progress){
#     cat('.')
#     progress <- progress + 1
#   }
# }
# cat('!\n')
# hist(train$density)
# train$density <- exp(-train$density/mean(train$density))
save(train, file="./data/mnist_train10k.rObj")
