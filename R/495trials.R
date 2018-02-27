##########################################
#######495 GLM vs NN results
##########################################

###prelim's... what you need???

###ggplot2, for diamonds dataset (normal response)
	require(ggplot2)
###gamelog_data, for box score + W/L dataset (categorical response)
	load("gamelog.RData")
###SEestimate.R, to find SE estimates for the model predictions
	source("~/R/SEestimate/SEestimate.R")
	

######create function to determine which trial to conduct
trial495<-function(
	#####argument trial version:  11, 12, 13, 21, 22, 23
		trials=NULL,
	#####data to append results to
		output=NULL
		)

{

######Test argument
if(!(trials %in% c(11:13,21:23))) stop("Argument 'trial' must be one of 11, 12, 13 or 21, 22, 23")

#####make sure output data has right format
if(!is.null(output) && ncol(output)!=5) stop("Argument 'output' must have 5 columns")


#############################################################
##########part one: GLM vs NN, normal response distribution
#############################################################

#-----------------------------------------------------------------------------------------------
#---trial 1.1: using 500 rows of diamonds, TRAIN glm/nn models on 450 data points,
#--------------TEST standard errors on 50 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

if(11 %in% trials) {
	###subset of diamonds to train/test
		dat<-diamonds[sample(nrow(diamonds),550),]
	###run SEestimate to approximate SE for GLM/NN models
		trial<-se.estimate(dat=dat,pred.var="price",resamples=50,test.size=50,method="both",distrib="continuous",prog.bar=T,timer=T)
	###create summary data frame for SEestimate
		temp<-data.frame(RESP=c(rep("Normal",100)),
				TEST.SIZE=rep(50,100),
				MODEL.TYPE=c(rep("GLM",50),rep("NN",50)),
				STANDARD.ERROR=unlist(c(trial[[1]],trial[[2]])),
				CREATE.TIME=unlist(c(trial[[5]],trial[[6]]))
				)
	####add summary data to output
		output<-rbind(output,temp)
	}

#-----------------------------------------------------------------------------------------------
#---trial 1.2: using 1000 rows of diamonds, TRAIN glm/nn models on 900 data points,
#--------------TEST standard errors on 100 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

if(12 %in% trials) {
	###subset of diamonds to train/test
		dat<-diamonds[sample(nrow(diamonds),1100),]
	###run SEestimate to approximate SE for GLM/NN models
		trial<-se.estimate(dat=dat,pred.var="price",resamples=50,test.size=100,method="both",distrib="continuous",prog.bar=T,timer=T)
	###create summary data frame for SEestimate
		temp<-data.frame(RESP=c(rep("Normal",100)),
				TEST.SIZE=rep(100,100),
				MODEL.TYPE=c(rep("GLM",50),rep("NN",50)),
				STANDARD.ERROR=unlist(c(trial[[1]],trial[[2]])),
				CREATE.TIME=unlist(c(trial[[5]],trial[[6]]))
				)
	####add summary data to output
		output<-rbind(output,temp)
	}

#-----------------------------------------------------------------------------------------------
#---trial 1.3: using 2000 rows of diamonds, TRAIN glm/nn models on 1800 data points,
#--------------TEST standard errors on 200 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

if(13 %in% trials) {
	###subset of diamonds to train/test
		dat<-diamonds[sample(nrow(diamonds),2200),]
	###run SEestimate to approximate SE for GLM/NN models
		trial<-se.estimate(dat=dat,pred.var="price",resamples=50,test.size=200,method="both",distrib="continuous",prog.bar=T,timer=T)
	###create summary data frame for SEestimate
		temp<-data.frame(RESP=c(rep("Normal",100)),
				TEST.SIZE=rep(200,100),
				MODEL.TYPE=c(rep("GLM",50),rep("NN",50)),
				STANDARD.ERROR=unlist(c(trial[[1]],trial[[2]])),
				CREATE.TIME=unlist(c(trial[[5]],trial[[6]]))
				)
	####add summary data to output
		output<-rbind(output,temp)
	}

##################################################################
##########part two: GLM vs NN, categorical response distribution
##################################################################

#-----------------------------------------------------------------------------------------------
#---trial 2.1: using 500 rows of bxdat, TRAIN glm/nn models on 450 data points,
#--------------TEST standard errors on 50 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

if(21 %in% trials) {
	###subset of gamelog_data to train/test
		dat<-datt[sample(nrow(datt),550),]
	###run SEestimate to approximate SE for GLM/NN models
		trial<-se.estimate(dat=dat,pred.var="WL",resamples=50,test.size=50,method="both",distrib="categorical",prog.bar=T,timer=T)
	###create summary data frame for SEestimate
		temp<-data.frame(RESP=c(rep("Binomial",100)),
				TEST.SIZE=rep(50,100),
				MODEL.TYPE=c(rep("GLM",50),rep("NN",50)),
				STANDARD.ERROR=unlist(c(trial[[1]],trial[[2]])),
				CREATE.TIME=unlist(c(trial[[5]],trial[[6]]))
				)
	####add summary data to output
		output<-rbind(output,temp)
	}

#-----------------------------------------------------------------------------------------------
#---trial 2.2: using 1000 rows of bxdat, TRAIN glm/nn models on 900 data points,
#--------------TEST standard errors on 100 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

if(22 %in% trials) {
	###subset of gamelog_data to train/test
		dat<-datt[sample(nrow(datt),1100),]
	###run SEestimate to approximate SE for GLM/NN models
		trial<-se.estimate(dat=dat,pred.var="WL",resamples=50,test.size=100,method="both",distrib="categorical",prog.bar=T,timer=T)
	###create summary data frame for SEestimate
		temp<-data.frame(RESP=c(rep("Binomial",100)),
				TEST.SIZE=rep(100,100),
				MODEL.TYPE=c(rep("GLM",50),rep("NN",50)),
				STANDARD.ERROR=unlist(c(trial[[1]],trial[[2]])),
				CREATE.TIME=unlist(c(trial[[5]],trial[[6]]))
				)
	####add summary data to output
		output<-rbind(output,temp)
	}

#-----------------------------------------------------------------------------------------------
#---trial 2.3: using 2000 rows of bxdat, TRAIN glm/nn models on 1800 data points,
#--------------TEST standard errors on 200 data points. repeat 50x, detect mean/median of s.e.
#-----------------------------------------------------------------------------------------------

if(23 %in% trials) {
	###subset of gamelog_data to train/test
		dat<-datt[sample(nrow(datt),2200),]
	###run SEestimate to approximate SE for GLM/NN models
		trial<-se.estimate(dat=dat,pred.var="WL",resamples=50,test.size=200,method="both",distrib="categorical",prog.bar=T,timer=T)
	###create summary data frame for SEestimate
		temp<-data.frame(RESP=c(rep("Binomial",100)),
				TEST.SIZE=rep(200,100),
				MODEL.TYPE=c(rep("GLM",50),rep("NN",50)),
				STANDARD.ERROR=unlist(c(trial[[1]],trial[[2]])),
				CREATE.TIME=unlist(c(trial[[5]],trial[[6]]))
				)
	####add summary data to output
		output<-rbind(output,temp)
	}


output}
