source("core.r")

# load preprocessed dataset
load("./data/covtype.rObj")

# split to TEST
test <- list()
test$x <- train$x[10001:13000, ]
test$y <- train$y[10001:13000]
test$n <- 3000
save(test, file="./data//covtype_test_3k.rObj")
cat("Test saves\n")

# split to TRAIN
train$x <- train$x[1:4000, ]
train$y <- train$y[1:4000]
train$n <- 4000

# Calc points density
# HINT: doesn't needed if options "ones" used in config in section density_weighting
# uncomment code below if you need it. 

# cat("Start to calculate density-weight\n", paste0(rep("-", 50), collapse=''), "\n")
# train$density <- array(0, nrow(train$x))
# progress <- 0
# for (i in 1:nrow(train$x)){
#   coord_diffs <- t(train$x) - matrix(as.numeric(train$x[i,]), ncol(train$x), nrow(train$x))
#   dists <- apply(coord_diffs, 2, function(x) {sqrt(sum(x*x))})
#   train$density[i] <- mean(exp(-dists/2000))
#   
#   if (floor(i/nrow(train$x)*50) > progress){
#     cat('.')
#     progress <- progress + 1
#   }
# }
# cat('!\n')
# hist(train$density)

#train$density <- train$density^1.44

save(train, file="./data/covtype_train_4k_dens.rObj")
