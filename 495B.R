##################################################
###############
#######comparing GLM vs nn for predictive analysis
##############
##################################################

compare<-function(dat=diamonds,pred="price"){

#escape if dat doesn't exist...   investigate 'args'	
#	if(exists(as.character(quote(dat)))){
#		}

	###identify predictive column in data frame
	names(dat)->vars
	which(vars==pred)->pred.col
	
	#####create formula for predictive model
	f<-paste(vars[-pred.col],collapse=" + ")
	f<-paste(vars[pred.col],"~",f)
	f<-as.formula(f)

	#######convert all data to numeric
	dat<-as.data.frame(lapply(dat,as.numeric))

###############################
#######neural net
##############
###############

#####unscale info for response
min(dat[,pred.col])->pred.min
max(dat[,pred.col])->pred.max
#####scale data
unlist(lapply(dat,min))->mins
unlist(lapply(dat,max))->maxs
as.data.frame(scale(dat,mins,maxs-mins))->dat.scaled

####split data into train/test subsets
sp<-sample.split(dat.scaled[,pred.col],0.70)
train<-subset(dat.scaled,sp==T)
test<-subset(dat.scaled,sp==F)

#####create neuralnet
nn<-neuralnet(f,train,hidden=c(10,10,10),linear.output=F)

#####predict
nn.pred<-compute(nn,test[,-pred.col])$net.result
test.response<-dat[which(sp==F),pred.col]

###compare
nn.results<-data.frame(NN=nn.pred,NNunscaled=pred.min+(pred.max-pred.min)*nn.pred,RESP=test.response)


########################
##
######### GLM
######
################

####train/test subsets
trainn<-subset(dat,sp==T)
testt<-subset(dat,sp==F)

###fit model
glm(f,,trainn)->glm.model

###predict 
predict(glm.model,testt)->glm.pred
as.numeric(glm.pred)->glm.predd

####compare
glm.results<-data.frame(GLM=glm.predd,GLMunscaled=glm.predd,RESP=test.response)

#####################
###output
#######################
results<-list(nn.results,glm.results)
results}
