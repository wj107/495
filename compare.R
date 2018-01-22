##################################################
##################################################
#######comparing GLM vs NN for predictive analysis
##################################################
##################################################

####require ggplot, neuralnet, caTools, else stop
##pkgs<-c("ggplot2","neuralnet","caTools")
##if(!(require(pkgs,quietly=T))) {stop}


####define function to compare predictive analysis between GLM and NN:
compare<-function(
	###N of data pts from 'diamonds' to be analyzed -- default = 500 sample data points
		N=500,	
	###response variable from data set. default to 'price' for diamonds.
		pred="price",					
	###percentage of data to be used as 'train' data set -- default 70%
		train.pct=0.70)				
	{

##########checking arguments else stop
##if(N>nrow(diamonds)) {stop}
##if(!is.data.frame(dat)) {stop}
##if(!(pred %in% names(dat))) {stop}
##if(!(train.pct>=0 && 1>=train.pct)) {stop}
	
	####define data frame
	dat<-diamonds[sample(53940,N),]
	###get variable names
	names(dat)->vars

######################code!!
	###identify predictive column in data frame
	which(vars==pred)->pred.col
	
	#####create formula for predictive model
	f<-paste(vars[-pred.col],collapse=" + ")
	f<-paste(vars[pred.col],"~",f)
	f<-as.formula(f)

	#######convert all data to numeric -- get rid of factors!!
	dat<-as.data.frame(lapply(dat,as.numeric))

	####create indexes for train/test subsets, according to train.pct
	sp<-sample.split(dat[,pred.col],train.pct)

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

########define train/test for NN w.scaled data
train<-subset(dat.scaled,sp==T)
test<-subset(dat.scaled,sp==F)

#####create neuralnet
nn<-neuralnet(f,train,hidden=c(10,10,10),linear.output=F)

#####predict with NN
nn.pred<-compute(nn,test[,-pred.col])$net.result
#####find actual response variables for comparison
test.response<-dat[which(sp==F),pred.col]

###compute NN Standard error
nn.se<-sum((nn.pred-test.response)^2)/length(test.response)

###compare -- organize predicted responses side-by-side w/actual responses
NN.results<-data.frame(NNscaled=nn.pred,NN=pred.min+(pred.max-pred.min)*nn.pred,RESP=test.response,NN.SE=nn.se)




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
as.data.frame(glm.pred)->glm.pred		

###compute GLM Standard error
glm.se<-sum((glm.pred-test.response)^2)/length(test.response)

####compare
GLM.results<-data.frame(GLM=glm.pred,RESP=test.response,GLM.SE=glm.se)

#####################
###output
#######################
results<-list(NN.results=NN.results,GLM.results=GLM.results)
results}
