d = read.csv("attractiveness_train.csv", header=TRUE)

pdf("age_vs_attractiveness.pdf", 15, 10)

men = d[which(( d$male) & (d$age>=14) & (d$age<=60)),];
women = d[which((!d$male) & (d$age>=14) & (d$age<=60)),];

opar = par( mfrow=c(2,3) );

hist(women$age, breaks=30, probability=TRUE, col="deeppink", main="female age")
rug(women$age, col="deeppink")
lines( density(women$age, na.rm=TRUE), col="purple", lwd=3 )

hist(women$attractive, breaks=20, probability=TRUE, col="deeppink", main="female attractiveness")
rug(women$attractive, col="deeppink")
lines( density(women$attractive, na.rm=TRUE), col="purple", lwd=3 )

women_age_2 = 2*round(women$age/2);
boxplot( women$attractive ~ women_age_2, ylim=c(1,3.5), col="deeppink",
	xlab="age", ylab="attractiveness", main="female attractiveness vs. age" );

hist(men$age, breaks=30, probability=TRUE, col="deepskyblue", main="male age")
rug(men$age, col="deepskyblue")
lines( density(men$age, na.rm=TRUE), col="blue", lwd=3 )

hist(men$attractive, breaks=20, probability=TRUE, col="deepskyblue", main="male attractiveness")
rug(men$attractive, col="deepskyblue")
lines( density(men$attractive, na.rm=TRUE), col="blue", lwd=3 )

men_age_2 = 2*round(men$age/2);
boxplot( men$attractive ~ men_age_2, ylim=c(1,3.5), col="deepskyblue",
	xlab="age", ylab="attractiveness", main="male attractiveness vs. age" );

par(opar)

dev.off()
