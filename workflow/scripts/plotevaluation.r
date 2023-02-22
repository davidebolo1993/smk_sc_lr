#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)
library(ggupset)
library(gridExtra)
library(tidyverse)

sessionInfo()
args <- commandArgs(trailingOnly=TRUE)
pathin<-file.path(args[1])
pathout<-file.path(args[2])

#knee plots
df<-fread(pathin)
p<-ggplot(df,aes(x=V1,y=V4,col=as.character(V3))) + 
  geom_point(size=.5, show.legend = F) +
  scale_y_log10() +
  scale_x_log10() +
  facet_grid(~V5) + 
  theme_bw() + 
  labs (x="CB", y="#CB") +
  theme(strip.background =element_rect(fill="grey20")) +
  theme(strip.text = element_text(colour = 'white')) +
  scale_color_manual(values=c("0" = "black", "1" = "#e34234"))


#upset plot
subdf<-subset(df, V3 == 1)
uni<-unique(subdf$V2)
labels<-list()

for (i in c(1:length(uni))) {
  
    subsubdf<-subset(subdf, V2 == uni[i])
    labels[[i]]<-subsubdf$V5
}

q<-as_tibble(cbind(uni, labels)) %>%
  ggplot(aes(x=labels)) +
  geom_bar() +
  scale_x_upset() +
  theme_bw () +
  geom_text(stat='count', aes(label=after_stat(count)), vjust=-.5, size=2.5) +
  labs(x="", y="Intersection Size") +
  theme_combmatrix(combmatrix.panel.point.color.fill = "#e34234",
                   combmatrix.panel.point.color.empty = "grey20",
                   combmatrix.panel.line.size = 0,
                   combmatrix.label.make_space = FALSE,
                   combmatrix.panel.striped_background.color.one = "grey90",
                   combmatrix.panel.striped_background.color.two = "lightyellow1")

empty<-ggplot() + theme_void()

t<-grid.arrange(empty,q,                                    
             p,                             
             ncol = 5, nrow = 2, 
             layout_matrix = rbind(c(1,2,2,2,1), c(3,3,3,3,3)))

ggsave(t, filename=pathout, width=12, height=15)
