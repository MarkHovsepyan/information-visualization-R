## libraries used in this script, please install  them before running the code
library(dplyr)
library(ggplot2)
library(ggcorrplot)
library(gridExtra)
library(ggrepel)
library(reshape2)
library(RColorBrewer)

## data fetching and preparation
pokemons <- read.csv('Pokemon.csv', stringsAsFactors = F)
pokemons$Legendary <- as.integer(as.logical(pokemons$Legendary))


## Correlation plot of all the stats of pokemons

stat_corr <- round(cor(poke_stats), 1)

hmap_attr <- pokemons[ -c(1:2, 4:5) ] # getting the necessary attributes

hmap_attr <- group_by(hmap_attr, Type.1)

hmap_attr <- summarise(hmap_attr, 
                       HP = median(HP), 
                       Attack = median(Attack), 
                       Defense = median(Defense), 
                       Sp_Atk = median(Sp..Atk), 
                       Sp_Def = median(Sp..Def), 
                       Speed = median(Speed))

row.names(hmap_attr) <- hmap_attr$Type.1
hmap_attr$Type.1 <- NULL

hmap_attr_cor <- cor(hmap_attr)

hmap_attr_cor_m <- melt(hmap_attr_cor)

hm.palette <- colorRampPalette(rev(brewer.pal(5, 'BuGn')))


ggplot(hmap_attr_cor_m, aes(Var1, Var2)) +
  geom_tile(aes(fill = value)) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  ggtitle("Pokemon Stat Correlation") +
  scale_fill_gradientn(colours = hm.palette(100)) +
  coord_equal()


## Density plots for main stats of the pokemons
ggplot(pokemons, aes(HP)) +
  geom_density(col="white", fill = "red", alpha = 0.7) +
  ggtitle("Density Plot of HP") + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"))

ggplot(pokemons, aes(Speed)) + 
  geom_density(col="white", fill = "darkorchid", alpha = 0.7) + 
  ggtitle("Density Plot of Speed") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"))


ggplot(pokemons, aes(Attack)) +
  geom_density(col="white", fill = "orange", alpha = 0.7) + 
  ggtitle("Density Plot of Attack") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"))


ggplot(pokemons, aes(Defense)) + 
  geom_density(col="white", fill = "slateblue1", alpha = 0.7) + 
  ggtitle("Density Plot of Defense") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"))



## Number of pokemons according to their types

## type 1
type_1_poke <- ggplot(pokemons, aes(Type.1)) +
  geom_bar(aes(fill=..count..), alpha=0.8) +
  theme(axis.text.x = element_text(angle = 90, hjust = 0),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ggtitle("Distribution of Type 1") +
  coord_flip()

## type 2
type_2_poke <- ggplot(pokemons, aes(Type.2)) +
  geom_bar(aes(fill=..count..), alpha=0.8) +
  theme(axis.text.x = element_text(angle = 90, hjust = 0),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ggtitle("Distribution of Type 2") +
  coord_flip()

grid.arrange(type_1_poke, type_2_poke, ncol=2)


## Defense vs Attack Scatterplot

##Note: the plot is a big one, please zoom the plot, so that the labels don't cover the surface
ggplot(pokemons, aes(Attack, Defense)) +
  geom_point(aes(color = Legendary), alpha = 0.8) +
  scale_color_gradient(low = "darkblue", high = "red") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ggtitle("Defense vs Attack") + 
  geom_label_repel(data = subset(pokemons, Attack > 150 | Defense > 150 | Attack < 25), 
                   aes(label = Name), 
                   box.padding = 0.35, point.padding = 0.5,
                   segment.color = 'grey50')


## Boxplot of powers of pokemons based on their primary type
ggplot(pokemons, aes(Type.1, Total, fill = Type.1)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ggtitle("Pokemon Power Based On Primary Type")





