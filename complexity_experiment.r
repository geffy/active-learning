# Comparing active and passive learning with fixed complexity.

source("./wrapper.r")

### make cfg struct ##############
opt <- list()
opt$file <- "./data/mnist_train10k.rObj"
opt$all_points <- 5000
opt$points_per_step <- 200
opt$test_size <- 0
opt$init_train_size <- 200
opt$limit <- -1
opt$test_file <- "./data/mnist_test_5k.rObj"

cfg <- def_cfg
cfg$data <- opt
cfg$model$ntrees <- 300
cfg$randomize <- F
cfg$density_weighted <- "ones"

current_cfg <- cfg


##### learn random with diff complexity
current_cfg$criteria_type <- "random"
current_cfg$model$maxnodes <- 100
random.100  <- full_processing(current_cfg, 'random.maxnodes=100')

current_cfg$criteria_type <- "random"
current_cfg$model$maxnodes <- 200
random.200  <- full_processing(current_cfg, 'random.maxnodes=200')

current_cfg$criteria_type <- "random"
current_cfg$model$maxnodes <- 400
random.400  <- full_processing(current_cfg, 'random.maxnodes=400')

### active learn with diff complexity
current_cfg$criteria_type <- "margin"
current_cfg$model$maxnodes <- 100
margin.100  <- full_processing(current_cfg, 'margin.maxnodes=100')
save.image("./tmp/maxnodes.exp.rImg")

current_cfg$criteria_type <- "margin"
current_cfg$model$maxnodes <- 200
margin.200  <- full_processing(current_cfg, 'margin.maxnodes=200')
save.image("./tmp/maxnodes.exp.rImg")

current_cfg$criteria_type <- "margin"
current_cfg$model$maxnodes <- 400
margin.400  <- full_processing(current_cfg, 'margin.maxnodes=400')
save.image("./tmp/maxnodes.exp.rImg")


### plot results  ###########
toPlot <- random.100$result
toPlot <- rbind(toPlot, margin.100$result)

toPlot <- rbind(toPlot, random.200$result)
toPlot <- rbind(toPlot, margin.200$result)

toPlot <- rbind(toPlot, random.400$result)
toPlot <- rbind(toPlot, margin.400$result)

accuracy_limit <- toPlot$accuracy[nrow(toPlot)]

thePlot <- ggplot() +
  xlab('points seen') + 
  ylab('accuracy') + 
  xlim(c(400, 5000))+
  ylim(c(0.78, 0.925))+
  #geom_line(data=NULL, aes(x=1:4000,y=accuracy_limit), colour="grey") + 
  geom_line(data=toPlot, aes(x=train_points,y=accuracy, colour=tag)) 
thePlot
