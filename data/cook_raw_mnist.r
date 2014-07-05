# Load the MNIST digit recognition dataset into R
# http://yann.lecun.com/exdb/mnist/
# files should be placed in ./raw_mnist/ folder

rm(list=ls())
library(pixmap)

load_mnist <- function() {
  load_image_file <- function(filename) {
    ret = list()
    f = file(filename,'rb')
    readBin(f,'integer',n=1,size=4,endian='big')
    ret$n = readBin(f,'integer',n=1,size=4,endian='big')
    nrow = readBin(f,'integer',n=1,size=4,endian='big')
    ncol = readBin(f,'integer',n=1,size=4,endian='big')
    x = readBin(f,'integer',n=ret$n*nrow*ncol,size=1,signed=F)
    ret$x = matrix(x, ncol=nrow*ncol, byrow=T)
    close(f)
    ret
  }
  load_label_file <- function(filename) {
    f = file(filename,'rb')
    readBin(f,'integer',n=1,size=4,endian='big')
    n = readBin(f,'integer',n=1,size=4,endian='big')
    y = readBin(f,'integer',n=n,size=1,signed=F)
    close(f)
    y
  }
  train <<- load_image_file('./data/raw_mnist/train-images.idx3-ubyte')
  test <<- load_image_file('./data/raw_mnist/t10k-images.idx3-ubyte')
  
  train$y <<- load_label_file('./data/raw_mnist/train-labels.idx1-ubyte')
  test$y <<- load_label_file('./data/raw_mnist/t10k-labels.idx1-ubyte')  
}

save(train, file="./data/mnist.rObj")
