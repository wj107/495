#########################################################
#########################################################
#######cross variation of GLM vs NN tofind standard error
#########################################################
#########################################################

####require ggplot, neuralnet, caTools, boot, plyr else stop
##pkgs<-c("ggplot2","neuralnet","caTools","boot","plyr")
##if(!(require(pkgs,quietly=T))) {stop}


####define function to compare predictive analysis between GLM and NN:
cvcompare<-function(
	###dat to be analyzed -- default = 500 sample data points from 'diamonds' data set
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

######define data set
dat<-diamonds[sample(53940,N),]

#########determine no. of groups to split data for cross-validation
groups<-round(1/(1-train.pct))

##########prep data
	###number of data points
	nrow(dat)->N

	###get variable names
	names(dat)->vars

	###identify predictive column in data frame
	which(vars==pred)->pred.col
	
	#####create formula for predictive model
	f<-paste(vars[-pred.col],collapse=" + ")
	f<-paste(vars[pred.col],"~",f)
	f<-as.formula(f)

	#######convert all data to numeric -- get rid of factors!!
	dat<-as.data.frame(lapply(dat,as.numeric))

	#####unscale info for response
	min(dat[,pred.col])->pred.min	
	max(dat[,pred.col])->pred.max
	#####scale data
	apply(dat,2,min)->mins
	apply(dat,2,max)->maxs			
	as.data.frame(scale(dat,mins,maxs-mins))->dat.scaled

################################
###########GLM cross-validation
###########using cv.glm
################################
	###first, fit model
	glm.model<-glm(as.formula(paste0(pred,"~.")),,dat)
	####next: call cv.glm
	cv.glm(dat,glm.model,K=groups)$delta[1]->glm.cv
	

###############################
###########NN cross-validation
###############################
	####initialize output variable
	nn.cv<-NULL
	####initialize progress bar (!)	
	pbar<-create_progress_bar('text')
	pbar$init(groups)

	#######train/test/compute SE  "groups" number of times
	for(i in 1:groups){
		###find index for train/test sets
		index<-sample(N,round(train.pct*N))
		####define train/set from scaled data
		train<-dat.scaled[index,]
		test<-dat.scaled[-index,]
		
		####create neuralnet!!
		nn<-neuralnet(f,train,hidden=c(10,10,10),linear.output=F)
		####predict, and re-scale:
		pred.nn<-compute(nn,test[,-pred.col])
		pred.nn<-pred.nn$net.result*(pred.max-pred.min)+pred.min
		####actual responses
		resp.nn<-test[,pred.col]*(pred.max-pred.min)+pred.min
		####calculate standard error
		nn.cv[i]<-sum((dat[-index,pred.col]-pred.nn)^2)/nrow(test)
		####step up
		pbar$step()
		}



#####################
###output
#######################
cv.results<-list(GLM.cv=glm.cv,NN.cv=nn.cv)
cv.results}
