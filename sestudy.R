###########################################################################
###########################################################################
########analyze standard error for a number of models of various sizes
###########################################################################
###########################################################################

#######define function to analyze standard errors for glm/nn models across repeated resamplings,
#######selecting one parameter to remain variable.
se.study.2d<-function(
	####select re-sampling parameter to vary
		param="resample.size"
	####select minimum value for parameter
		param.min,
	####select maximum value for parameter
		param.max,
	####select number of steps for parameter
		param.steps=10,
	####select step value for parameter
		param.step.value=NULL,
	####select methods used to calculate standard error
		method="both"
	)
	{

###possible methods:  ensure 'method' arg is valid
method.options<-c("glm", "nn", "both")
##if(!(method %in% method.options)) {stop}


