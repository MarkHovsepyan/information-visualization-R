## libraries used in this script, please install  them before running the code
library(ggplot2)
library(RColorBrewer)

## data fetching and preparation
pokemons <- read.csv('Pokemon.csv', stringsAsFactors = F)
pokemons$Legendary <- as.integer(as.logical(pokemons$Legendary))


new_pallete <- colorRampPalette(rev(brewer.pal(5, 'OrRd')))

ggplot(pokemons, aes(Type.1)) +
  geom_bar(aes(fill=..count..), alpha=0.8) +
  scale_fill_gradientn(colours = new_pallete(100)) +
  theme(axis.text.x = element_text(angle = 20, hjust = 0, colour = "#B30000"),
        axis.text.y = element_text(angle = 20, hjust = 0, colour = "#050711"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "#050711",
                                        colour = "#050711",
                                        size = 0.5, linetype = "solid"),
        axis.line = element_line(colour = "black"),
        plot.background = element_rect(fill = "#B30000")) +
  ggtitle("Distribution of Type 1 by Generation") +
  coord_polar() +
  facet_wrap(. ~ Generation) +
  theme(strip.text.x = element_text(size = 8, colour = "#B30000"),
        strip.text.y = element_text(size = 12, face = "bold", colour = "#B30000"),
        strip.background = element_rect(colour = "#050711", fill = "#050711"))

