# Visualization

library(ggplot2)

initPlot <- function(MainLabel='Plane', XLabel='X', YLabel='Y'){
  gg <- ggplot() + 
    labs(title=MainLabel) +
    xlab(XLabel) + 
    ylab(YLabel) + 
    theme_bw()
  return(gg)
}

addPointsToPlot <- function(df, plot, mode = 'train'){
  if (mode == 'cursor'){
    plot <- plot + 
      geom_point(data=df, aes(x=X,y=Y),colour="black", shape = 2,  size=5) 
    return(plot)
  }
  
  if (mode == 'unseen'){
    plot <- plot + 
      geom_point(data=df, aes(x=X,y=Y),colour="black", shape = 3,  size=1.2) 
    return(plot)
  }
  
  idx <- (df$ans > 0)
  class1 <- df[idx,]
  class0 <- df[!idx,]
  if (mode == 'train'){
    plot <- plot + 
      geom_point(data=class1, aes(x=X,y=Y),colour="red",shape = 17,  size=3) +
      geom_point(data=class0, aes(x=X,y=Y),colour="blue",shape = 17, size=3) 
  }
  if (mode == 'test'){
    plot <- plot + 
      geom_point(data=class1, aes(x=X,y=Y),colour="#CC79A7", shape = 1, size=3) +
      geom_point(data=class0, aes(x=X,y=Y),colour= "#0072B2", shape = 1,  size=3) 
  }
  return(plot)
}