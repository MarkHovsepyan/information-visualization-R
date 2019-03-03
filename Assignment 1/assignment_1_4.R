## libraries used in this script, please install them before running the code
library(ggplot2)
library(RColorBrewer)
library(RCurl)

## Data fetching and preparation
got_battles <- read.csv('battles.csv', stringsAsFactors = F)

## Which King had the most attacks?
ggplot(data = got_battles, aes(x = factor(attacker_king))) +
  geom_bar(aes(fill = factor(attacker_king)), width=1, colour="black") +
  xlab("Attacker King") +
  ylab("Number of Battles Fought") +
  ggtitle("") +
  theme(axis.text.x = element_blank())

## Which King was attacked the most?
ggplot(data = got_battles, aes(x = factor(defender_king))) +
  geom_bar(aes(fill = factor(defender_king)), width=1, colour="black") +
  xlab("Attacker King") +
  ylab("Number of Battles Fought") +
  ggtitle("") +
  theme(axis.text.x = element_blank())


## Does the size of the army decide the outcome of the battle?
ggplot(data = got_battles, aes(x = defender_size, y = attacker_size)) +
  geom_point(aes(color = attacker_outcome)) + 
  geom_smooth(method = "lm", se = F, fullrange = T, colour = "steelblue", size = 1) +
  geom_smooth(method = "loess", formula = y ~ x, se = F, colour = "red", size = 2) +
  ggtitle("Army sizes and Outcomes of Battles") +
  xlab("Defender Size") + ylab("Attacker Size")
  
## Larger army size does not guarantee a victory for the attacker.
## However, with the linear regression line we can see that there is a slight inclination,
## the more is the army of the defender the likelier is the loss.
## The Loess lines shows a bit different pattern indicating that the size isn't very important after all.


## How did the commanders of the attacking army perform?
ggplot(data = got_battles, aes(x = factor(attacker_commander), fill = attacker_outcome)) +
  geom_bar(aes(fill = factor(attacker_outcome))) +
  facet_wrap(~ attacker_king) + 
  coord_flip() +
  ggtitle("Attacker Kings and Their Commanders") +
  xlab("Attacker Commanders") + ylab("Number of Battles") +
  scale_fill_manual(values=c("#0a9b4b", "#E69F00", "#b20c51")) +
  theme( plot.background = element_rect(fill = "#1d355b"),
         panel.grid.minor = element_blank(),
         panel.background = element_rect(fill = "#1d355b",
                                         colour = "#1d355b",
                                         size = 0.5, linetype = "solid"),
         strip.text = element_text(size = 12, face = "bold", colour = "white"),
         strip.background = element_rect(colour = "#1d355b", fill = "#1d355b"),
         legend.background = element_rect(fill = "#1d355b", 
                                         size=0.5, linetype="solid"),
         legend.title = element_text(colour = "white", size = 10, 
                                    face = "bold"),
         legend.text = element_text(colour = "white", size = 10, 
                                   face = "bold"),
         axis.title = element_text(colour = "white"),
         axis.text = element_text(colour = "white"),
         plot.title = element_text(colour = "white") )
  
## Here we observe that Gregor Clegane fought the most victorious battles 
## and had no losses as a commander serveing for Joffrey and Tommen Baratheons.


## Regions of battles and the kings who fought them!
ggplot(data = got_battles, aes(x = factor(attacker_king))) +
  geom_bar(aes(fill = factor(attacker_outcome)), width=1, colour="black") +
  facet_wrap(~ region) + 
  coord_flip() +
  ggtitle("Regions and Battles") +
  xlab("Attacker Kings") + ylab("Number of Battles") +
  theme(panel.background = element_blank())

## Here we can see the regions where the kings fought.
## Turns out every king has fought some battles in the North.
## interesting observation is that Joffrey and Tommen fought mostly in The Riverlands.
## It's their homeland so they fought battles to protect their interests and won most of those.













