###load data!
	load("R/cdc.RData")

###create glm model

	glm1<-glm(cdc$weight ~ cdc$height)
###use to predict
	pred1<-data.frame(height=cdc$height,weight=predict(glm1))
###trim prediction, between 50,83 inches
	pred1<-pred1[(pred1[,1]>50 & pred1[,1]<83),]


####plot! and save!!
	ggplot(cdc,aes(height,weight))+
	geom_point(alpha=1/8)+
	geom_line(dat=pred1,color="red",size=3,aes(height,weight))+
	xlim(50,85)+ylim(100,400)+xlab("HEIGHT")+ylab("WEIGHT")
	ggsave("img/model1.png")


###create nn model


###scale cdc data
#---find min/max
	min.h<-min(cdc$height)
	max.h<-max(cdc$height)
	min.w<-min(cdc$weight)
	max.w<-max(cdc$weight)
	
	h1<-scale(cdc$height,min.h,max.h-min.h)
	w1<-scale(cdc$weight,min.w,max.w-min.w)
###collect in data frame
	cdc1<-data.frame(h1,w1)
###create nn	
	neuralnet(w1~h1,cdc1,hidden=c(3,3),linear.output=F)->nn
###scale predictor var's for prediction
	h2<-scale(51:82,min.h,max.h-min.h)
###predict!!!
	compute(nn, h2)$net.result->w2

###re-scale back.
	w2<-min.w+w2*(max.w-min.w)

	pred2<-data.frame(height=51:82,weight=w2)
	

####plot! and save!!
	ggplot(cdc,aes(height,weight))+
	geom_point(alpha=1/8)+
	geom_line(dat=pred2,color="red",size=3,aes(height,weight))+
	xlim(50,85)+ylim(100,400)+xlab("HEIGHT")+ylab("WEIGHT")
	ggsave("img/model2.png")
