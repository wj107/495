###grid package
	require(grid)

###start it up...
	grid.newpage()

###create boxes

#----predictors
	b11<-boxGrob("Predictor Variable #1",x=0.125,y=0.65)
	b12<-boxGrob("Predictor Variable #2",x=0.125,y=0.35)

#----hidden level #1
	b21<-boxPropGrob("Neuron #1","Linear Combination", "Activation Function",prop=0.5,
		x=0.375,y=.75,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))
	b22<-boxPropGrob("Neuron #2","Linear Combination", "Activation Function",prop=0.5,
		x=0.375,y=.5,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))
	b23<-boxPropGrob("Neuron #3","Linear Combination", "Activation Function",prop=0.5,
		x=0.375,y=.25,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))

#----hidden level #2
	b31<-boxPropGrob("Neuron #4","Linear Combination", "Activation Function",prop=0.5,
		x=0.62,y=.75,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))
	b32<-boxPropGrob("Neuron #5","Linear Combination", "Activation Function",prop=0.5,
		x=0.62,y=.5,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))
	b33<-boxPropGrob("Neuron #6","Linear Combination", "Activation Function",prop=0.5,
		x=0.62,y=.25,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))
	
#----responses
	b4<-boxPropGrob("Responses","Linear Combination","Activation Function", prop=0.5,
		x=0.825,box_left_gp=gpar(fill="red"),box_right_gp=gpar(fill="blue"))

###default arrow style
	options(connectGrobArrow=arrow(angle=7,type="closed"))

###red arrows
	options(connectGrob=gpar(lwd=3,fill="red",col="red"))

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
	png(filename="../img/nnchart.png",width=2000)

	#---start plot w/title
	plot.new()
	title(main=list("Mappings in a NN predictive model",cex=2.2))

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
