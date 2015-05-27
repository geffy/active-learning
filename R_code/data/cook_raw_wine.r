# Data shuold be downloaded form
# https://archive.ics.uci.edu/ml/machine-learning-databases/wine/
# and placed into ./raw_wine/ folder

data <- read.csv(file='./data//raw_wine//winequality-white.csv', sep=';')
train <- list()
N <- nrow(data)
ind <- sample(1:N, N, replace=F)
train$x <- data[ind,1:11]
train$y <- data[ind,12]
save(train, file='./data/wine.rObj')