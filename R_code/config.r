# This file describe structure "cfg".
# Some fields may be unsed.

# [datasets]
data_mnist <- list()
data_mnist$file <- "./data/mnist_pca20.rObj"
data_mnist$all_points <- 10000
data_mnist$points_per_step <- 200
data_mnist$test_size <- 5000
data_mnist$init_train_size <- 200
data_mnist$limit <- 2200
data_mnist$test_file <- ""

data_covtype <- list()
data_covtype$file <- "./data/covtype.rObj"
data_covtype$all_points <- 7000
data_covtype$points_per_step <- 200
data_covtype$test_size <- 3000
data_covtype$init_train_size <- 200
data_covtype$limit <- 4000
data_covtype$test_file <- ""

data_wine <- list()
data_wine$file <- "./data/wine.rObj"
data_wine$all_points <- 4890
data_wine$points_per_step <- 100
data_wine$test_size <- 1390
data_wine$init_train_size <- 200
data_wine$limit <- 3500
data_wine$test_file <- NULL

# [models]
def_rf <- list()
def_rf$type <- 'rf'
def_rf$ntrees <- 1000
def_rf$mtry <- 5
def_rf$nodesize <- 1

def_svm <- list()
def_svm$type <- 'svm'

def_gbm <- list()
def_gbm$type <- 'gbm'
def_gbm$int_depth <- 10
def_gbm$ntree_predict <- 250
def_gbm$ntree_learn <- 300



def_glm <- list()
def_glm$type <- 'glm'
def_glm$nlambda <- 50
def_glm$nfolds <- 3

# default setup
def_cfg <- list()
def_cfg$data <- data_covtype
def_cfg$model <- def_rf
def_cfg$criteria_type <- 'margin'
def_cfg$randomize <- T

# "calc" for every load, "read" from file or just "ones"
def_cfg$density_weighted <- 'ones'


