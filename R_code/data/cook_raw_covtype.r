# Data should be downloaded from 
# https://archive.ics.uci.edu/ml/machine-learning-databases/covtype/
# and unpacked into ./raw_covtype/ folder

# main structure - list "train", which consist of "x" and "y".

data <- read.csv(file='./data//raw_covtype//covtype.data', sep=',')
train <- list()
N <- nrow(data)
ind <- sample(1:N, N, replace=F)
train$x <- data[ind,1:54]
train$y <- data[ind,55]
save(train, file='./data/covtype.rObj')