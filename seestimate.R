###################################################################
###################################################################
#######estimating standard error of GLM/NN models via resampling
###############
#######but now looping both GLM and NN... not using cv.glm
#######now use ALL of 'diamonds' to sample from, not just a subset
#########################################################
#########################################################

####require ggplot, neuralnet, caTools, boot, plyr else stop
##pkgs<-c("ggplot2","neuralnet","caTools","boot","plyr")
##if(!(require(pkgs,quietly=T))) {stop}


####define function to compare predictive analysis between GLM and NN:
se.estimate<-function(
	####number of sample groups to draw		
		resamples=100,
	#####size of sample groups
		resample.size=500,
	#####pct of data used to re-sample. will override resample.size if given 
		resample.pct=NULL,		
	###percentage of data to be used as 'train' data set -- default 70%
		train.pct=0.70,
	###select method used to calculate standard error
		method="both")
	{

####possible methods; make sure 'method' arg is valid
method.options<-c("glm","nn","both")
##if(!(method %in% method.options)) {stop}

######define data set
dat<-diamonds
N<-nrow(diamonds)

##########checking arguments else stop
##if(!is.integer(resamples)) {stop}
if(!is.null(resample.pct)) resample.size<-round(N*resample.pct)
##if(!is.integer(resample.size)) {stop}
##if(!(resample.size>=0 && resample.size<=N)) {stop}
##if(!(train.pct>=0 && 1>=train.pct)) {stop}


######define response variable
pred.var<-"price"

##########prep data
	###get variable names
	names(dat)->vars

	###identify predictive column in data frame
	which(vars==pred.var)->resp.col
	
	#####create formula for predictive model
	model.formula<-paste(vars[-resp.col],collapse=" + ")
	model.formula<-paste(vars[resp.col],"~",model.formula)
	model.formula<-as.formula(model.formula)

	#######convert all data to numeric -- get rid of factors!!
	dat<-as.data.frame(lapply(dat,as.numeric))

	#####unscale info for response
	min(dat[,resp.col])->resp.min	
	max(dat[,resp.col])->resp.max
	#####scale data
	apply(dat,2,min)->mins
	apply(dat,2,max)->maxs			
	as.data.frame(scale(dat,mins,maxs-mins))->dat.scaled

################################
###########GLM se.estimate
################################
	######check if glm is tested
	if(method=="glm" || method=="both"){

	####initialize output variable
	glm.se.estimate<-NULL
	####initialize progress bar (!)	
	##name="Re-sampling data K times to calculate standard error of GLM model"
	pbar<-create_progress_bar('text')
	pbar$init(resamples)

	#######train/test/compute SE  "groups" number of times
	for(i in 1:resamples){
		###find index for re-sampling set
		resample<-sample(N,resample.size)
		###divide re-sample into test/train index
		train.index<-sample(resample.size,round(train.pct*resample.size))
		####define train/set from data
		train<-dat[resample[train.index],]
		test<-dat[resample[-train.index],]
		
		####create glm!!
		glm.model<-glm(model.formula,,train)
		####predict from model:
		pred.glm<-predict(glm.model,test)
		####actual responses
		resp.glm<-test[,resp.col]
		####calculate standard error
		glm.se.estimate[i]<-sum((pred.glm-resp.glm)^2)/nrow(test)
		####step up
		pbar$step()
		}
	##end glm estimate
	}


###############################
###########NN se.estimate
###############################
	######check if nn is tested
	if(method=="nn" || method=="both"){
	####initialize output variable
	nn.se.estimate<-NULL
	####initialize progress bar (!)	
	##name="Re-sampling data K times to calculate standard error of NN model"
	pbar<-create_progress_bar('text')
	pbar$init(resamples)

	#######train/test/compute SE  "groups" number of times
	for(i in 1:resamples){
		###find index for re-sampling set
		resample<-sample(N,resample.size)
		###divide re-sample into test/train index
		train.index<-sample(resample.size,round(train.pct*resample.size))
		####define train/set from scaled data
		train<-dat.scaled[resample[train.index],]
		test<-dat.scaled[resample[-train.index],]
		
		####create neuralnet!!
		nn<-neuralnet(model.formula,train,hidden=c(10,10,10),linear.output=F)
		####predict, and re-scale:
		pred.nn<-compute(nn,test[,-resp.col])
		pred.nn<-pred.nn$net.result*(resp.max-resp.min)+resp.min
		####actual responses
		resp.nn<-test[,resp.col]*(resp.max-resp.min)+resp.min
		####calculate standard error
		nn.se.estimate[i]<-sum((resp.nn-pred.nn)^2)/nrow(test)
		####step up
		pbar$step()
		}
	###end nn estimates
	}


#####################
###output
#######################

######if method=glm
	if(method=="glm") se.results<-list(GLM.se.estimate=glm.se.estimate,GLM.summary=summary(glm.se.estimate)) 

######if method=glm
	if(method=="nn") se.results<-list(NN.se.estimate=nn.se.estimate,NN.summary=summary(nn.se.estimate)) 

######if method=glm
	if(method=="both") se.results<-list(GLM.se.estimate=glm.se.estimate,NN.se.estimate=nn.se.estimate,GLM.summary=summary(glm.se.estimate),NN.summary=summary(nn.se.estimate)) 

####output results
se.results}
