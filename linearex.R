####################################################################
#####simple neural net vs glm example using linear relationship
####################################################################

#######raw data
###predictor variable
x=0:1000
N<-length(x)
###actual response:   y=0.6x
y.act<-0.6*x
####response w/noise   y=0.6x+D
y.obs<-0.6*x + rnorm(N,,8)
###in data frame
dat.raw<-data.frame(X=x,OBS=y.obs,ACT=y.act)

########normalized data
###find max/min's
apply(dat.raw,2,min)->mins
apply(dat.raw,2,max)->maxs
dat.scaled<-as.data.frame(scale(dat.raw,mins,maxs-mins))

####create index set to divide data into train/test
###use 75% train
index<-sample(N,round(0.75*N))

###create train/test dataframes, distinguish GLM/NN data
####for NN...scaled data!!!
train.nn<-dat.scaled[index,1:2]
test.nn<-dat.scaled[-index,1]

####for GLM...raw data!!!
train.glm<-dat.raw[index,1:2]
test.glm<-dat.raw[-index,1:2]

################################
############NEURAL NET

#####create the model!!
neuralnet(OBS ~ X, train.nn, hidden=c(3,1))->nn

#####use model to predict!
####find scaled responses
compute(nn,test.nn)$net.result->pred.nn
####convert to raw responses
pred.nn*(max(y.obs)-min(y.obs))+min(y.obs)->pred.nn

####compute SE for responses.
MSE.nn<-sum((pred.nn-y.obs[-index])^2)/(length(N)-length(index))
#####find UL/LL form MSE.  Use 95% CI.
ul.nn<-pred.nn+1.96*MSE.nn
ll.nn<-pred.nn-1.96*MSE.nn

#######################################
################GLM!!

#####create the model!!
glm(OBS ~ X,,train.glm)->glm.model
#####predict w/model!   include SE
as.data.frame(predict(glm.model,test.glm,se.fit=T))->pred.glm
#####use SE to find upper/lower limits on responses.  Use 95% CI.
ul.glm<-pred.glm$fit+1.96*pred.glm$se.fit
ll.glm<-pred.glm$fit-1.96*pred.glm$se.fit


###output!!!
####from X, OBS, ACT of test data, plus pred from NN & GLM.  UL/LL from GLM
output<-data.frame(dat.raw[-index,],PRED.NN=pred.nn,UL.NN=ul.nn,LL.NN=ll.nn,PRED.GLM=pred.glm$fit,UL.GLM=ul.glm,LL.GLM=ll.glm)

####graphed!
nn.plot<-ggplot(output,aes(X))+
	geom_line(size=0.2,aes(y=ACT))+
	geom_point(color="black",alpha=1/2,aes(y=OBS))+
	geom_point(color="blue",alpha=1/3,aes(y=PRED.NN))+
	geom_ribbon(aes(ymin=LL.NN,ymax=UL.NN),fill="blue",alpha=1/2)

glm.plot<-ggplot(output,aes(X))+
	geom_line(size=0.2,aes(y=ACT))+
	geom_point(color="black",alpha=1/2,aes(y=OBS))+
	geom_point(color="red",alpha=1/3,aes(y=PRED.GLM))+
	geom_ribbon(aes(ymin=LL.GLM,ymax=UL.GLM),fill="red",alpha=1/2)
