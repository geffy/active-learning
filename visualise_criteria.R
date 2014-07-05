rm(list=ls())
source("./wrapper.r")
library(ggplot2)
library(lattice)

# see B.Settle "Active Learning literature survey" for deatail.
# This this implementation of toy visualisation

calc_probs <- function(inp){
  # ideal triagle
  p1 <- c(0, 0)
  p2 <- c(1, sqrt(3))
  p3 <- c(2, 0)
  
  d1 <- sqrt(sum((p1 - inp)^2))
  d2 <- sqrt(sum((p2 - inp)^2))
  d3 <- sqrt(sum((p3 - inp)^2))
  sD <- d1+d2+d3
  ans <- (1 - (c(d1, d2,d3) / sD)) /2 + rnorm(3, 0, 0.000001)  
  # add some noise for exclude situation with complitely equal probability 
  return(ans)
}

draw_criteria <- function(criteria_type, plot_type='2D'){
  if (plot_type == '2D'){
    points_grid <- expand.grid(x=seq(-1, 3, 0.01), y=seq(-1, 3, 0.01))
  }
  if (plot_type == '3D'){
    points_grid <- expand.grid(x=seq(-2, 4, 0.1), y=seq(-2, 4, 0.1))
  }
  cat('Calc probs...\n')
  probs <- t(apply(points_grid, 1, calc_probs))
  cat('Calc scores...\n')
  scores <- -1* apply(probs, 1, function(x) {criteria(x, criteria_type)})
  result <- cbind(points_grid, scores)
  cat('Done!\n')
  
  if (plot_type == '2D'){
  plot <- ggplot() + 
    geom_tile(data=result, aes(x=x, y=y, fill=scores)) + scale_fill_continuous(guide=F) + coord_fixed() + 
    ggtitle(paste('Criteria:',criteria_type))
  }
  if (plot_type == '3D') {
    for (angle in seq(0, 350, 10)){
      cat('\t', paste("./vis/3D/", criteria_type, '/', angle, ".jpg", collapse='', sep=''), '\n')
      jpeg(filename=paste("./vis/3D/", criteria_type, '/', angle, ".jpg", collapse='', sep=''), 
          type="cairo",
          units="px", 
          width=400, 
          height=400)
      trellis.par.set("axis.line", list(col="transparent"))
      
      print(wireframe(scores ~ x * y, data=result, screen = list(z = angle, x = 120, y= 0), drape = T, colorkey=F))
      
      dev.off()
      
    }
  }
  return(plot)
}

#mrg <- draw_criteria('margin')
#ent <- draw_criteria('entropy')
#rnd <- draw_criteria('random')
#minmax <- draw_criteria("minmax", plot_type="3D")
