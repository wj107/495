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
	#####pct of data used to re-sample. will override resample.size if given 
		resample.pct=NULL,		
	#####size of re-sample groups (valid only if resample.pct is not defined)
		resample.size=500,
	###percentage of re-sample data to be used as 'train' data set -- default 70%
		train.pct=0.70,
	###select method(s) used to calculate standard error -- "glm", "nn", "both"
		method="both",
	###progress bar?  T or F
		prog.bar=T)
	{

######define data set
dat<-diamonds
N<-nrow(dat)
######define response variable
pred.var<-"price"

#######check argument:  'resamples'
if(!(resamples==round(resamples) && resamples>0)) stop("Argument `resamples' must be a positive integer")
#######check argument:  'resample.pct'  does it exist?  is it valid?  then, override resample.size
if(!is.null(resample.pct)) {
	if(!(resample.pct>0 && resample.pct<=1)) stop("Argument `resample.pct' must be a value greater than zero and less than or equal to 1")
	resample.size<-round(N*resample.pct)
	}
#######check argument:  'resample.size'
if(!(resample.size==round(resample.size) && resample.size>0)) stop("Argument `resample.size' must be a positive integer")
if(resample.size>N) stop("Argument `resample.size' exceeds rows in data set")
#######check argument:  'train.pct'
if(!(train.pct>0 && train.pct<1)) stop("Argument `train.pct' must be a value between zero and one, exclusive")
#######possible methods; make sure 'method' arg is valid
method.options<-c("glm","nn","both")
if(!(method %in% method.options)) stop("Argument `method' must be one of `glm', `nn', or `both'")
#######check argument: 'prog.bar'
if(!is.logical(prog.bar)) stop("Argument `prog.bar' must be logical")


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
		#####if prog.bar=T, initialize progress bar
		if(prog.bar){
			print("Re-sampling data, creating and testing models, to calculate standard error for a GLM model")
			progress.bar<-create_progress_bar('text')
			progress.bar$init(resamples)
			}
		#######train/test/compute SE  "resamples" number of times
		for(i in 1:resamples){
			###find index for re-sampling set
			resample.index<-sample(N,resample.size)
			###divide re-sample into test/train index
			train.index<-sample(resample.size,round(train.pct*resample.size))
			####define train/set from data
			train<-dat[resample.index[train.index],]
			test<-dat[resample.index[-train.index],]
		
			####create glm!!
			glm.model<-glm(model.formula,,train)
			####predict from model:
			pred.glm<-predict(glm.model,test)
			####actual responses
			resp.glm<-test[,resp.col]
			####calculate standard error
			glm.se.estimate[i]<-sum((pred.glm-resp.glm)^2)/nrow(test)
			####if prog.bar=T, step up
			if(prog.bar) progress.bar$step()
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
		#####if prog.bar=T, initialize progress bar
		if(prog.bar){
			print("Re-sampling data, creating and testing models, to calculate standard error for a NN model")
			progress.bar<-create_progress_bar('text')
			progress.bar$init(resamples)
			}
		#######train/test/compute SE  "resamples" number of times
		for(i in 1:resamples){
			###find index for re-sampling set
			resample.index<-sample(N,resample.size)
			###divide re-sample into test/train index
			train.index<-sample(resample.size,round(train.pct*resample.size))
			####define train/set from scaled data
			train<-dat.scaled[resample.index[train.index],]
			test<-dat.scaled[resample.index[-train.index],]
		
			####create neuralnet!!
			nn<-neuralnet(model.formula,train,hidden=c(10,10,10),linear.output=F)
			####predict, and re-scale:
			pred.nn<-compute(nn,test[,-resp.col])
			pred.nn<-pred.nn$net.result*(resp.max-resp.min)+resp.min
			####actual responses
			resp.nn<-test[,resp.col]*(resp.max-resp.min)+resp.min
			####calculate standard error
			nn.se.estimate[i]<-sum((resp.nn-pred.nn)^2)/nrow(test)
			####if prog.bar=T, step up
			if(prog.bar) progress.bar$step()
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
