source("./wrapper.r")

# Comparing diff Active Learning approaches

### make cfg struct ##############
opt <- list()
opt$file <- "./data/covtype_train_7k.rObj"
opt$all_points <- 5000
opt$points_per_step <- 200
opt$test_size <- 0
opt$init_train_size <- 200
opt$limit <- -1
opt$test_file <- "./data/covtype_test_4k.rObj"

cfg <- def_cfg
cfg$data <- opt
cfg$model$ntrees <- 300
cfg$randomize <- F

current_cfg <- cfg
##################################

current_cfg$criteria_type <- "entropy"
entropy <- full_processing(current_cfg, 'entropy')

current_cfg$criteria_type <- "margin"
margin  <- full_processing(current_cfg, 'margin')

current_cfg$criteria_type <- "minmax"
minmax  <- full_processing(current_cfg, 'minmax')

current_cfg$criteria_type <- "random"
random  <- full_processing(current_cfg, 'random')

#####################################

toPlot <- entropy$result
toPlot <- rbind(toPlot, margin$result)
toPlot <- rbind(toPlot, minmax$result)
toPlot <- rbind(toPlot, random$result)


accuracy_limit <- toPlot$accuracy[nrow(toPlot)]

thePlot <- ggplot() +
  xlab('points seen') + 
  ylab('accuracy') + 
  xlim(c(100, 5000))+
  ylim(c(0.60, 0.8))+
  #geom_line(data=NULL, aes(x=1:4000,y=accuracy_limit), colour="grey") + 
  geom_line(data=toPlot, aes(x=train_points,y=accuracy, colour=criteria)) + 
  theme_bw()
thePlot

save.image("./tmp/current_tmp2.rImg")

# rorpPlot <- ggplot() +
#   labs(title = paste('Multi-class active learning criteria comparing.
#     MNIST(10 classes), RF(1000 trees), PCA(20 dim),', 
#                      PPS," PPS, ", 
#                      overall_points - test_size, 'points'))+
#   xlab('points seen') + 
#   ylab('RORP (Rate Of Right Predicted)') + 
#   #geom_line(data=NULL, aes(x=1:(overall_points - test_size),y=rorp), colour="grey") + 
#   geom_line(data=toPlot, aes(x=train_points,y=rorp, colour=criteria_type)) + 
#   theme_bw()
# rorpPlot
