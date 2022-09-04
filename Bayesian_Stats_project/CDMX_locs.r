library(rstan)
library(ggplot2)
library(cowplot)
library(magrittr)
library(dplyr)
library(ggExtra)
library(brms)
library(reshape2)
library(bcogsci)
library(ggrepel)
library(patchwork)
library(loo)

set.seed(142)
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
#path_ <- "/home/kchinas/GitHub/Air-Quality-in-Mexico-City/Bayesian_Stats_project/data"

pre <- read.csv("pre_data_.csv")

pre %>% 
  ggplot(aes(CO_ppm, NOX_ppb)) + 
  geom_point() + 
  facet_wrap("location")

h <- hist(pre$NOX_ppb, breaks=15, plot=F)
plot(h, xlab ="NOX [ppb]", main="", col="lightgray")
###############################################################################
############################################################### NORMAL  #######
###############################################################################


fit_n <- brm(
  NOX_ppb ~ CO_ppm + (CO_ppm|location),
  data = pre,
  family = gaussian(),
  prior = c(
#    prior(normal(45, 5), class="Intercept"),
#    prior(normal(0,1), class="sigma"),
    prior(normal(50, 15), class = "Intercept"),
    prior(normal(0,25), class   = "sigma"),    
    prior(normal(0,1), class="b", coef=CO_ppm)
  ),
  control = list(adapt_delta = 0.999)
)

conds <- data.frame(location = unique(pre$location))
me_normal <- conditional_effects(fit_n, 
                          conditions = conds,
                          re_formula = NULL, 
                          method = "pp")
plot(me_normal, points = TRUE) 
print(fit_n, priors=T)
pp_check(fit_n, ndraws = 100) + scale_x_continuous("NOX [ppb]")
mcmc_plot(fit_n, type = "trace")



###############################################################################
############################################################### LOG NORMAL  ###
###############################################################################


fit_ln <- brm(
  NOX_ppb ~ CO_ppm + (CO_ppm|location),
  data = pre,
  family = lognormal(),
  prior = c(
    prior(normal(3.78, 0.11), class="Intercept"),
    prior(normal(0,0.25), class="sigma"),
    prior(normal(0,1), class="b", coef=CO_ppm)
  ),
  control = list(adapt_delta = 0.999999)
)

conds <- data.frame(location = unique(pre$location))
me_lognormal <- conditional_effects(fit_ln, 
                          conditions = conds,
                          re_formula = NULL, 
                          method = "pp")
plot(me_lognormal, points = TRUE) 
print(fit_ln, priors=T)
pp_check(fit_ln, ndraws = 100) + scale_x_continuous("NOX [ppb]")

mcmc_plot(fit_ln, type = "trace")

###############################################################################
##########################################################   LOG  GAMMA  ######
###############################################################################


fit_lgamma <- brm(
  NOX_ppb ~ CO_ppm + (CO_ppm|location),
  data = pre,
  family = Gamma(link="log"),
  prior = c(
    prior(normal(3.78, 0.11), class="Intercept"),
    prior(normal(0,1), class="b", coef=CO_ppm),
    prior(gamma(0.01,0.01),class="shape")
  ),
  control = list(adapt_delta = 0.99999)
)

conds <- data.frame(location = unique(pre$location))
me_lgamma <- conditional_effects(fit_lgamma, 
                          conditions = conds,
                          re_formula = NULL, 
                          method = "pp",
                          )
plot(me_lgamma, points = TRUE) 


print(fit_lgamma, priors=T)
pp_check(fit_lgamma, ndraws = 100) + scale_x_continuous("NOX [ppb]")

mcmc_plot(fit_lgamma, type = "trace")


###############################################################################
################   Model Evaluation    ########################################
## Bridgesampling   ###########################################################
#logml_m1 <- bridge_sampler(fit_n)
#logml_m2 <- bridge_sampler(fit_ln)
#logml_m3 <- bridge_sampler(fit_lgamma)
#(post_prob(logml_m1, logml_m2, logml_m3, logml_m4))


###############################################################################
###############################################################################




## LOO-CV  ####################################################################

M <- list(
  fit_n, 
  fit_ln, 
  fit_lgamma 
)

J <- length(M)

loo_list <- list()

for (j in 1:J){
  m <- M[[j]]
  ll <- as.matrix(m, variable = "ll")
  loo_list[[j]] <- loo(ll)
}

# Compare LOO-ELPD of all three models
do.call(loo_compare, loo_list)


