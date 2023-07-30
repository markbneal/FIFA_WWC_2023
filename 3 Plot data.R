# 3 Plot data

library(tidyr)
library(dplyr)
library(purrr)
library(stringr)

library(ggplot2)
library(ggrepel)
library(ggpmisc)
library(ggExtra)


data_df_join <- readRDS("data_df_join.RDS")

# Plot results ####
# geom repel error
# https://stackoverflow.com/a/68084961/4927395
# x11()
p <- ggplot(data = data_df_join, aes(x = rank_diff, y = point_diff))+
  geom_rect(mapping=aes(xmin=-80, xmax=80, ymin=-0.5, ymax=0.5), fill = "blue", color=NA, alpha=0.005) +
  geom_point()+
  #geom_jitter() +
  geom_smooth(method = "lm", formula = "y ~ x") +
  xlab("Rank Difference (Away - Home)")+
  ylab("Point Difference (Home - Away)")+
  annotate("text", x=40, y=-5, label = "Unexpected Upset", colour = "red")+
  annotate("text", x=-60, y=0, label = "Draw", colour = "blue")+
  scale_y_continuous(breaks = seq(-6, 6, by = 1))+
  theme(panel.grid.major.y = element_line(color = "darkgrey",
                                          size = 0.25,
                                          linetype = 1))+
  theme(panel.grid.minor.y = element_blank())+
  annotate("text", x=-40, y=5, label = "Hammering by more than expected", colour = "darkgreen")+
  ggtitle("Greater rank differences typically lead to \ngreater point differences")+
  #geom_text(aes(label = game), size=3 )
  geom_text_repel(aes(label = game)) # caused error on workbench

p
ggsave("rank difference vs point difference.png")

p1 <- ggMarginal(p, type="histogram")
p1
class(p1)

ggsave(p1, "rank difference vs point difference with marginals.png") #doesn't save properly


q <- ggplot(data = data_df_join, aes(x = abs_rank_diff, y = rel_point_diff))+
  geom_rect(mapping=aes(xmin=0, xmax=70, ymin=-0.5, ymax=0.5), fill = "blue", color=NA, alpha=0.005) +
  #geom_point()+
  geom_jitter(width = 0, height = 0.2, alpha = 0.2) +
  geom_smooth(method = "lm", formula = "y ~ x") +
  #stat_poly_line(formula = "y ~ x", orientation = "x", na.rm = TRUE) +
  stat_poly_eq(use_label(c("eq", "adj.R2")), formula = "y ~ x", orientation = "x", na.rm = TRUE, size = 3) +
  xlab("Rank Difference (Lesser rank - Greater rank)") +
  ylab("Point Difference in favour of greater ranked team" )+
  annotate("text", x=40, y=-3, label = "Unexpected Upset", colour = "red")+
  annotate("text", x=60, y=0, label = "Draw", colour = "blue")+
  scale_y_continuous(breaks = seq(-6, 6, by = 1))+
  theme(panel.grid.major.y = element_line(color = "darkgrey",
                                          size = 0.25,
                                          linetype = 1))+
  theme(panel.grid.minor.y = element_blank())+
  annotate("text", x=40, y=5, label = "Hammered by more than expected", colour = "darkgreen")+
  ggtitle("Greater rank differences typically lead to \ngreater point differences")+
  #geom_text(aes(label = game), size=3 )
  geom_text_repel(aes(label = game), size = 3) # caused error

q

ggsave("absolute-rank-difference-vs-point-difference.png", height = 8, width = 7)

q1 <- ggMarginal(q, type="histogram")
q1

ggsave("absolute rank difference vs point difference with marginals.png") #doesn't save properly

