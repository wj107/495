##################################################
##################################################
#######comparing GLM vs NN for predictive analysis
##################################################
##################################################

####require ggplot, neuralnet, caTools, else stop

####define function to compare predictive analysis between GLM and NN:
compare<-function(
	###dat to be analyzed -- default = 50 sample data points from 'diamonds' data set
		dat=diamonds[sample(53940,50),],	
	###response variable from data set. default to 'price' for diamonds.
		pred="price",					
	###percentage of data to be used as 'train' data set -- default 70%
		train.pct=0.70)				
	{

##########checking arguments else stop
#escape if dat doesn't exist...   investigate 'args'	
#	if(exists(as.character(quote(dat)))){
#		}

	###get variable names
	names(dat)->vars

##escape  if pred is not in vars...

##escape if train.pct is not between 0 & 1....


######################code!!
	###identify predictive column in data frame
	which(vars==pred)->pred.col
	
	#####create formula for predictive model
	f<-paste(vars[-pred.col],collapse=" + ")
	f<-paste(vars[pred.col],"~",f)
	f<-as.formula(f)

	#######convert all data to numeric -- get rid of factors!!
	dat<-as.data.frame(lapply(dat,as.numeric))

########################
#######neural net
#########################
#########################

#####unscale info for response
min(dat[,pred.col])->pred.min	
max(dat[,pred.col])->pred.max
#####scale data
unlist(lapply(dat,min))->mins
unlist(lapply(dat,max))->maxs			
as.data.frame(scale(dat,mins,maxs-mins))->dat.scaled

####split data into train/test subsets, according to train.pct
sp<-sample.split(dat.scaled[,pred.col],train.pct)
train<-subset(dat.scaled,sp==T)
test<-subset(dat.scaled,sp==F)

#####create neuralnet
nn<-neuralnet(f,train,hidden=c(10,10,10),linear.output=F)

#####predict with NN
nn.pred<-compute(nn,test[,-pred.col])$net.result
#####find actual response variables for comparison
test.response<-dat[which(sp==F),pred.col]

###compare -- organize predicted responses side-by-side w/actual responses
NN.results<-data.frame(NN=nn.pred,NNunscaled=pred.min+(pred.max-pred.min)*nn.pred,RESP=test.response)


########################
#######################
######### GLM
#######################
#######################

####train/test subsets
trainn<-subset(dat,sp==T)
testt<-subset(dat,sp==F)

###fit model
glm(f,,trainn)->glm.model

###predict 
predict(glm.model,testt)->glm.pred
as.numeric(glm.pred)->glm.predd		

####compare
GLM.results<-data.frame(GLM=glm.predd,GLMunscaled=glm.predd,RESP=test.response)

#####################
###output
#######################
results<-list(NN.results=NN.results,GLM.results=GLM.results)
results}
