##########################################
#######495 GLM vs NN results
##########################################

###prelim's... what you need???

###ggplot2, for diamonds dataset (normal response)
	require(ggplot2)
###bxdat.R, for bxdat dataset (categorical response)
	load("bxdat.R")
###seestimate.R, to find se estimates for the model predictions
	source("seestimate.R")

#############################################################
##########part one: GLM vs NN, normal response distribution
#############################################################

#-----------------------------------------------------------------------------------------------
#---trial 1.1: using 500 rows of diamonds, TRAIN glm/nn models on 450 data points,
#--------------TEST standard errors on 50 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

#dat1.1<-diamonds[sample(nrow(diamonds),500),]
#trial1.1<-se.estimate(dat=dat1.1,pred.var="price",resamples=50,test.pct=0.10,method="both",distrib="continuous",prog.bar=T)

#-----------------------------------------------------------------------------------------------
#---trial 1.2: using 1000 rows of diamonds, TRAIN glm/nn models on 900 data points,
#--------------TEST standard errors on 100 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

#dat1.2<-diamonds[sample(nrow(diamonds),1000),]
#trial1.2<-se.estimate(dat=dat1.2,pred.var="price",resamples=50,test.pct=0.10,method="both",distrib="continuous",prog.bar=T)

#-----------------------------------------------------------------------------------------------
#---trial 1.3: using 2000 rows of diamonds, TRAIN glm/nn models on 1800 data points,
#--------------TEST standard errors on 200 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

#dat1.3<-diamonds[sample(nrow(diamonds),2000),]
#trial1.3<-se.estimate(dat=dat1.3,pred.var="price",resamples=50,test.pct=0.10,method="both",distrib="continuous",prog.bar=T)

##################################################################
##########part two: GLM vs NN, categorical response distribution
##################################################################

#-----------------------------------------------------------------------------------------------
#---trial 2.1: using 500 rows of bxdat, TRAIN glm/nn models on 450 data points,
#--------------TEST standard errors on 50 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

#dat2.1<-datt[sample(nrow(datt),500),]
#trial2.1<-se.estimate(dat=dat2.1,pred.var="WL",resamples=50,test.pct=0.10,method="both",distrib="categorical",prog.bar=T)

#-----------------------------------------------------------------------------------------------
#---trial 2.2: using 1000 rows of bxdat, TRAIN glm/nn models on 900 data points,
#--------------TEST standard errors on 100 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

dat2.2<-datt[sample(nrow(datt),1000),]
trial2.2<-se.estimate(dat=dat2.2,pred.var="WL",resamples=50,test.pct=0.10,method="both",distrib="categorical",prog.bar=T)

#-----------------------------------------------------------------------------------------------
#---trial 2.3: using 2000 rows of bxdat, TRAIN glm/nn models on 1800 data points,
#--------------TEST standard errors on 200 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

dat2.3<-datt[sample(nrow(datt),2000),]
trial2.3<-se.estimate(dat=dat2.3,pred.var="WL",resamples=50,test.pct=0.10,method="both",distrib="categorical",prog.bar=T)

