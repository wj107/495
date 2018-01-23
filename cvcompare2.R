#########################################################
#########################################################
#######cross variation of GLM vs NN tofind standard error
###############
#######but now looping both GLM and NN... not using cv.glm
#########################################################
#########################################################

####require ggplot, neuralnet, caTools, boot, plyr else stop
##pkgs<-c("ggplot2","neuralnet","caTools","boot","plyr")
##if(!(require(pkgs,quietly=T))) {stop}


####define function to compare predictive analysis between GLM and NN:
cvcompare<-function(
	###dat to be analyzed -- default = 500 sample data points from 'diamonds' data set
		N=500,
	####number of re-sample groups to draw		
		K=100,
	#####size of sample groups
		K.size=round(N*0.10),			
	###percentage of data to be used as 'train' data set -- default 70%
		train.pct=0.70)				
	{


##########checking arguments else stop
##if(!is.integer(N)) {stop}
##if(N>nrow(diamonds)) {stop}
##if(!is.integer(K)) {stop}
##if(!is.integer(K.size)) {stop}
##if(!(K.size<=0 && K.size>=N)) {stop}
##if(!(train.pct>=0 && 1>=train.pct)) {stop}

######define data set
dat<-diamonds[sample(53940,N),]
######define response variable
pred<-"price"

##########prep data
	###get variable names
	names(dat)->vars

	###identify predictive column in data frame
	which(vars==pred)->resp.col
	
	#####create formula for predictive model
	f<-paste(vars[-resp.col],collapse=" + ")
	f<-paste(vars[resp.col],"~",f)
	f<-as.formula(f)

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
###########GLM cross-validation
################################
	####initialize output variable
	glm.cv<-NULL
	####initialize progress bar (!)	
	##name="Re-sampling data K times to calculate standard error of GLM model"
	pbar<-create_progress_bar('text')
	pbar$init(K)

	#######train/test/compute SE  "groups" number of times
	for(i in 1:K){
		###find index for re-sampling set
		resample<-sample(N,K.size)
		###divide re-sample into test/train index
		train.index<-sample(K.size,round(train.pct*K.size))
		####define train/set from data
		train<-dat[resample[train.index],]
		test<-dat[resample[-train.index],]
		
		####create glm!!
		glm.model<-glm(f,,train)
		####predict from model:
		pred.glm<-predict(glm.model,test)
		####actual responses
		resp.glm<-test[,resp.col]
		####calculate standard error
		glm.cv[i]<-sum((pred.glm-resp.glm)^2)/nrow(test)
		####step up
		pbar$step()
		}

###############################
###########NN cross-validation
###############################
	####initialize output variable
	nn.cv<-NULL
	####initialize progress bar (!)	
	##name="Re-sampling data K times to calculate standard error of NN model"
	pbar<-create_progress_bar('text')
	pbar$init(K)

	#######train/test/compute SE  "groups" number of times
	for(i in 1:K){
		###find index for re-sampling set
		resample<-sample(N,K.size)
		###divide re-sample into test/train index
		train.index<-sample(K.size,round(train.pct*K.size))
		####define train/set from scaled data
		train<-dat.scaled[resample[train.index],]
		test<-dat.scaled[resample[-train.index],]
		
		####create neuralnet!!
		nn<-neuralnet(f,train,hidden=c(10,10,10),linear.output=F)
		####predict, and re-scale:
		pred.nn<-compute(nn,test[,-resp.col])
		pred.nn<-pred.nn$net.result*(resp.max-resp.min)+resp.min
		####actual responses
		resp.nn<-test[,resp.col]*(resp.max-resp.min)+resp.min
		####calculate standard error
		nn.cv[i]<-sum((resp.nn-pred.nn)^2)/nrow(test)
		####step up
		pbar$step()
		}



#####################
###output
#######################
cv.results<-list(GLM.cv=glm.cv,NN.cv=nn.cv,GLM.summary=summary(glm.cv),NN.summary=summary(nn.cv))
cv.results}
