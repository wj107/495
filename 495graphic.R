########################################################################
######from 'dat' data frame of standard errors, represent graphically
########################################################################

####require data!
	load("495proj.R")

###create base plots
	plot1<-ggplot(subset(dat,RESP=="Normal"),aes(x=as.factor(TEST.SIZE),y=STANDARD.ERROR))
	plot2<-ggplot(subset(dat,RESP=="Binomial"),aes(x=as.factor(TEST.SIZE),y=STANDARD.ERROR))

###create boxplot
	bx<-geom_boxplot(alpha=1/5,outlier.alpha=0,aes(color=MODEL.TYPE,fill=MODEL.TYPE))
	
###create points
	pts<-geom_point(size=4,alpha=1/3,position=position_jitterdodge(),aes(color=MODEL.TYPE))

####create titles
	ttl1<-ggtitle("STANDARD ERRORS for GLM and NN predictive models, given NORMALLY DISTRIBUTED RESPONSE")
	ttl2<-ggtitle("STANDARD ERRORS for GLM and NN predictive models, given BINOMIALLY DISTRIBUTED RESPONSE")
	
####xlabel
	x<-xlab("Size of Testing Data Set")

####ylim's
	y1<-ylim(0,2e6)
	y2<-ylim(0,0.3)

###plots!!
	P1<-plot1+bx+pts+ttl1+x+y1
	P2<-plot2+bx+pts+ttl2+x+y2

