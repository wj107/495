###grid package
	require(grid)

###start it up...
	grid.newpage()

###create boxes

#----predictors
	b11<-boxGrob("Predictor #1",x=0.125,y=0.65)
	b12<-boxGrob("Predictor #2",x=0.125,y=0.35)

#----hidden level #1
	b21<-boxGrob("Layer #1: Neuron #1",x=0.375,y=.75)
	b22<-boxGrob("Layer #1: Neuron #2",x=0.375,y=.5)
	b23<-boxGrob("Layer #1: Neuron #3",x=0.375,y=.25)

#----hidden level #2
	b31<-boxGrob("Layer #2: Neuron #1",x=0.62,y=.75)
	b32<-boxGrob("Layer #2: Neuron #2",x=0.62,y=.5)
	b33<-boxGrob("Layer #2: Neuron #3",x=0.62,y=.25)

#----responses
	b4<-boxGrob("Responses",x=0.825)
###default arrow style
	options(connectGrobArrow=arrow(angle=7,type="closed"))

###black arrows
	options(connectGrob=gpar(lwd=3,fill="black",col="black"))

#-----from predictors
	c111<-connectGrob(b11,b21,type="horizontal")
	c112<-connectGrob(b11,b22,type="horizontal")
	c113<-connectGrob(b11,b23,type="horizontal")
	
	c121<-connectGrob(b12,b21,type="horizontal")
	c122<-connectGrob(b12,b22,type="horizontal")
	c123<-connectGrob(b12,b23,type="horizontal")

#-----from first level of hidden neurons
	c211<-connectGrob(b21,b31,type="horizontal")
	c212<-connectGrob(b21,b32,type="horizontal")
	c213<-connectGrob(b21,b33,type="horizontal")
	
	c221<-connectGrob(b22,b31,type="horizontal")
	c222<-connectGrob(b22,b32,type="horizontal")
	c223<-connectGrob(b22,b33,type="horizontal")

	c231<-connectGrob(b23,b31,type="horizontal")
	c232<-connectGrob(b23,b32,type="horizontal")
	c233<-connectGrob(b23,b33,type="horizontal")
	
#----to responses)

	c314<-connectGrob(b31,b4,"horizontal")
	c324<-connectGrob(b32,b4,"horizontal")
	c334<-connectGrob(b33,b4,"horizontal")

###PLOT!!
	#---open connection
	png(filename="../img/nnmodel.png",width=2000)

	#---start plot w/title
	plot.new()
	title(main=list("Structure of a NN Model with 2 Hidden Layers",cex=2.2))

	#----plot boxes
	plot(b11); plot(b12)
	plot(b21); plot(b22); plot(b23)
	plot(b31); plot(b32); plot(b33)
	plot(b4)

	#----plot arrows
	plot(c111); plot(c112); plot(c113)
	plot(c121); plot(c122); plot(c123)

	plot(c211); plot(c212); plot(c213)
	plot(c221); plot(c222); plot(c223)
	plot(c231); plot(c232); plot(c233)

	plot(c314); plot(c324); plot(c334)
	
	#----close connection
	dev.off()
