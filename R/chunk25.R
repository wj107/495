
###load NBA game data
	load("gamelog.RData")

#--------------BAD BINOMIAL

###extract only PTS and WL
	datt[,20:21]->dat

####create a 'bad' glm:
	glm1<-glm(WL~PTS,data=dat)

####create a data frame for (bad) predictive model:
	pred1<-data.frame(X=dat$PTS,Y=predict(glm1))

####graph it and save!!
	ggplot(dat,aes(PTS,WL))+geom_point(alpha=1/20,position=position_jitter(height=0.05))+
	geom_line(dat=pred1,color="red",size=3,aes(X,Y))
	ggsave("../img/binomialbad.png", height=4, width=8)

#---------------GOOD BINOMIAL


####create a `good' GLM:
	glm2<-glm(WL~PTS,data=dat,family=binomial)
	
####create a data frame for (bad) predictive model:
	pred2<-data.frame(X=dat$PTS,Y=predict(glm2,type="response"),Y2=predict(glm2))

####graph it and save!!
	ggplot(dat,aes(PTS,WL))+geom_point(alpha=1/20,position=position_jitter(height=0.05))+
	geom_line(dat=pred2,color="red",size=1,alpha=1/4,aes(X,Y2))+
	geom_line(dat=pred2,color="blue",size=3,aes(X,Y))+
	ylim(-1,2)
	ggsave("../img/binomialgood.png", height=4, width=8)
		

