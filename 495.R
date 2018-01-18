##################################################
###############
#######cleaning and analyzing data for predictive analysis

##################################################


#############load data frame

load("lakers1617.R")

###load("~/Desktop/lakers1617.R")



#####create formula for predictive model

f<-paste(names(bx)[-20],collapse=" + ")

f<-paste("WL ~",f)

f<-as.formula(f)



###############################

#######neural net
##############
###############

##

#####scale data

unlist(lapply(bx,min))->mins

unlist(lapply(bx,max))->maxs

as.data.frame(scale(bx,mins,maxs-mins))->bx.scaled



####split data into train/test subsets

sp<-sample.split(bx.scaled$WL,0.70)

train<-subset(bx.scaled,sp==T)

test<-subset(bx.scaled,sp==F)



#####create neuralnet

nn<-neuralnet(f,train,hidden=c(10,10,10),linear.output=F)



#####predict

nn.pred<-compute(nn,test[,-20])$net.result

test.response<-bx$WL[sp==F]



###compare

results<-data.frame(NN=nn.pred,NNrounded=round(nn.pred),RESP=test.response)



########################
##
######### GLM
######
################

##

####train/test subsets

trainn<-subset(bx,sp==T)

testt<-subset(bx,sp==F)



###fit model
glm(f,,trainn)->glm.model



###predict 

predict(glm.model,testt)->glm.pred

as.numeric(glm.pred)->glm.predd



####compare

results2<-data.frame(GLM=glm.predd,GLMrounded=round(glm.predd),RESP=test.response)




######################
###
#####summary



#######glm summary

glm.correct<-sum(round(glm.predd)==test.response)

glm.incorrect<-sum(round(glm.predd)!=test.response)

glm.pct<-glm.correct/(glm.correct+glm.incorrect)



######nn summary

nn.correct<-sum(round(nn.pred)==test.response)

nn.incorrect<-sum(round(nn.pred)!=test.response)

nn.pct<-nn.correct/(nn.correct+nn.incorrect)



########summary matrix

pred.sum<-c(glm.correct,glm.incorrect,glm.pct,nn.correct,nn.incorrect,nn.pct)

pred.sum<-matrix(pred.sum,nrow=2,byrow=T)

rownames(pred.sum)<-c("GLM","Neural Net")

colnames(pred.sum)<-c("Correct", "Incorrect","Percentage")




#########################
###############
###########raw data for graphing

##########################

###########
###

#######need to re-do....scaling data first before graphing



#####unlist stats
unlist(bx.scaled[,-20])->stats



#####creating stats names

names(stats)->names.raw

pat<-"\\d+$"

stat.names<-substr(names.raw,1,regexpr(pat,names.raw)-1)

games<-paste("Game",substring(names.raw,regexpr(pat,names.raw)))



######outcome

rep(bx$WL,19)->WL



########raw data frame

dat<-data.frame(G=games,STAT=stat.names,STAT2=stats,outcome=WL,row.names=NULL)

