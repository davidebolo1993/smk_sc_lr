#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)

sessionInfo()
args <- commandArgs(trailingOnly=TRUE)
pathin<-file.path(args[1])
pathout<-file.path(args[2])

df<-fread(pathin)

p<-ggplot(df, aes(fill=tool, y=value, x=category, col=tool)) + 
  geom_bar(position="dodge", stat="identity",linewidth = .5) + 
  theme_bw() + 
  scale_colour_brewer(palette = "Greys", direction=-1) + 
  scale_fill_brewer(palette = "RdBu", direction=-1)+
  theme(legend.title = element_blank()) + 
  facet_wrap(~broad_category, scales = "free", nrow=1, strip.position = "left", labeller = as_labeller(c(memory = "memory (GB)", time = "time (H)") )) +
  theme(strip.background =element_rect(fill="grey20")) +
  theme(strip.placement = "outside",strip.background = element_blank(), legend.title=element_blank()) +
  labs(x="",y="")

ggsave(p, filename=pathout,width=15, height=10)

