########################################################################
######from 'dat' data frame of standard errors, represent graphically
########################################################################

########create a function to represent SE approximations, graphically
graph495<-function(
	####data frame with SE estimates
		dat=NULL,
	####graph results from normal, binomial, or both
		distrib="normal",
	####display plots or not save
		disp=T
		)
	{

####check argument dat
###this test needs some work!!
if(names(dat)!=c("RESP","TEST.SIZE","MODEL.TYPE","STANDARD.ERROR")) stop("Argument 'dat' must be data.frame with data from SE estimate trials")
####check argument distrib
if(!(distrib %in% c("normal","binomial","both"))) stop("Argument 'distrib' must be one of 'normal', 'binomial', or 'both'")


####create plot for normal response trials
if(distrib=="normal" || distrib=="both"){
	###create base plots
		p<-ggplot(subset(dat,RESP=="Normal"),aes(x=as.factor(TEST.SIZE),y=STANDARD.ERROR))
	###create boxplot
		bx<-geom_boxplot(alpha=1/5,outlier.alpha=0,aes(color=MODEL.TYPE,fill=MODEL.TYPE))
	###create points
		pts<-geom_point(size=4,alpha=1/3,position=position_jitterdodge(),aes(color=MODEL.TYPE))
	####create titles
		ttl<-ggtitle("STANDARD ERRORS for GLM and NN predictive models, given NORMALLY DISTRIBUTED RESPONSE")
	####xlabel
		x<-xlab("Size of Testing Data Set")
	####ylim's
		y<-ylim(0,2e6)
	###plots!!
		P<-p+bx+pts+ttl+x+y
	###save plot!  
	###Need to work on dimensions
		ggsave("normal_plot.png",P)
	}


####create plot for binomial response trials
if(distrib=="binomial" || distrib=="both"){
	###create base plots
		p<-ggplot(subset(dat,RESP=="Binomial"),aes(x=as.factor(TEST.SIZE),y=STANDARD.ERROR))
	###create boxplot
		bx<-geom_boxplot(alpha=1/5,outlier.alpha=0,aes(color=MODEL.TYPE,fill=MODEL.TYPE))
	###create points
		pts<-geom_point(size=4,alpha=1/3,position=position_jitterdodge(),aes(color=MODEL.TYPE))
	####create titles
		ttl<-ggtitle("STANDARD ERRORS for GLM and NN predictive models, given BINOMIALLY DISTRIBUTED RESPONSE")
	####xlabel
		x<-xlab("Size of Testing Data Set")
	####ylim's
		y<-ylim(0,0.3)
	###plots!!
		P<-p+bx+pts+ttl+x+y
	###save plot!
		ggsave("binomial_plot.png",P)
	}

##until you learn to display two graphs in one function call!!
	if(disp==T && distrib=="both") print("Graphs must be displayed individually")
	if(disp==T && distrib!="both") P
}
