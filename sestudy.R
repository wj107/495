###########################################################################
###########################################################################
########analyze standard error for a number of models of various sizes
###########################################################################
###########################################################################

#######define function to analyze standard errors for glm/nn models across repeated resamplings,
#######selecting one parameter to remain variable.
se.study.2d<-function(
	####select re-sampling parameter to vary
		param="resample.size",
	####select minimum value for parameter
		param.min,
	####select maximum value for parameter
		param.max,
	####select number of steps for parameter
		param.step.number=10,
	####select step value for parameter  ...will override param.step.number if given
		param.step.value=NULL,
	####select methods used to calculate standard error
		method="glm"
	)
	{

###possible methods:  ensure 'method' arg is valid
method.options<-c("glm", "nn", "both")
##if(!(method %in% method.options)) {stop}
if(!is.null(param.step.value)) param.step.number<-round((param.max-param.min)/param.step.value)

####define the steps for parameter to study
param.steps<-round(seq(param.min,param.max,,param.step.number))
#####how big is each resample??
resamples<-100


#####initialize output variable
resample.sizes<-rep(param.steps,each=resamples)
list()->standard.error

#####initialize progress bar 
pbar<-create_progress_bar("text")
pbar$init(param.step.number)

#####loop through steps, call seestimate for each step
for(i in param.step.number){
	param.value<-param.steps[i]
	se.estimate(resamples,resample.size=param.value,train.pct=0.70,method=method)[[1]]->standard.error[[i]]
	pbar$step()
	}

standard.error<-unlist(standard.error)
output<-data.frame(resample.size=resample.sizes,standard.error=standard.error)
output}
