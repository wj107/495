###grid package
	require(grid)

###start it up...
	grid.newpage()

###create boxes
	b11<-boxGrob("Predictor Variable #1",x=0.2,y=0.7)
	b12<-boxGrob("Predictor Variable #2",x=0.2,y=0.5)
	b13<-boxGrob("Predictor Variable #3",x=0.2,y=0.3)

	b2<-boxGrob("Linear Combination",x=0.5,box_gp=gpar(fill="red"))
	b3<-boxGrob("Responses",x=0.8,box_gp=gpar(fill="blue"))

###default arrow style
	options(connectGrobArrow=arrow(angle=7,type="closed"))

###red arrows
	options(connectGrob=gpar(lwd=3,fill="red",col="red"))
	c11<-connectGrob(b11,b2,type="horizontal")
	c12<-connectGrob(b12,b2,type="horizontal")
	c13<-connectGrob(b13,b2,type="horizontal")

###blue arrow
	options(connectGrob=gpar(lwd=3,fill="blue",col="blue"))
	c2<-connectGrob(b2,b3,"horizontal")

###PLOT!!
	#---open connection
	png(filename="../img/glmchart.png",width=1000)

	#---start plot w/title
	plot.new()
	title(main=list("Mappings in a GLM predictive model",cex=2.2))

	#----plot boxes
	plot(b11); plot(b12); plot(b13)
	plot(b2)
	plot(b3)

	#----plot arrows
	plot(c11); plot(c12); plot(c13)
	plot(c2)
	
	#----close connection
	dev.off()
