library(ggplot2)

accidents <- read.csv('accidents_2017.csv', stringsAsFactors = F)

ggplot(accidents, aes(x = Victims)) +
  geom_histogram(fill = 'blue', binwidth = 0.3) +
  ylab("Number of Accidents")
