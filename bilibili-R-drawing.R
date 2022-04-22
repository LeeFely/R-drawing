#####################################
##              饼图             ##
#####################################
data()
class(rivers)
plot(rivers)
hist(rivers)
class(state.abb)
pie(table(state.abb))
yanse <- c("red","green","blue","yellow")

pie(table(state.abb),col = yanse)
labs <- c("NC","S","N","W")
pie(table(state.abb),labels = labs)
class(state.division)
plot(mtcars$cyl,mtcars$disp)
plot(as.factor(mtcars$disp),mtcars$cyl)
heatmap(state.x77)
heatmap(as.data.frame(state.x77))
fit <- lm(weight~height,data=women)
class(fit)
plot(fit)



#####################################
##              直方图             ##
#####################################
example("barplot")
example("heatmap")
library(ggplot2)
example("qplot")
help("barplot")
??barplot


#####################################
##          ???Ľ? barplot         ##
#####################################
getwd()
setwd("c:/Users/wangtong/Desktop/")
m <- read.csv("Rdata/homo_length.csv",header = T)
m
class(m)
head(m)
x <- m[1:24,]
x
class(x$length)
barplot(height = x$length)
barplot(height = x$length,names.arg = x$chr)
yanse <- sample(colours(),24,replace = F)
barplot(height = x$length,names.arg = x$chr,col = yanse)
barplot(height = x$length,names.arg = x$chr,col = rainbow(7))
barplot(height = x$length,names.arg = x$chr,col = rainbow(7),border = F)
barplot(height = x$length,names.arg = x$chr,col = rainbow(7),border = F,
        main = "Human chromosome length distribution",xlab = "Chromosome Name",ylab = "Chromosome Length")




#####################################
##        ??5?? ????????ͼ         ##
#####################################
 
x <- read.csv("Rdata/sv_distrubution.csv",header = T,row.names = 1)
x
barplot(x)
barplot(as.matrix(x))
barplot(t(as.matrix(x)))
barplot(t(as.matrix(x)),col = rainbow(4))
barplot(t(as.matrix(x)),col = rainbow(4),beside = T)
barplot(t(as.matrix(x)),col = rainbow(4),legend.text = colnames(x))
barplot(t(as.matrix(x)),col = rainbow(4),legend.text = colnames(x),ylim = c(0,800))
barplot(t(as.matrix(x)),col = rainbow(4),legend.text = colnames(x),ylim = c(0,800),
        main = "SV Distribution",xlab="Chromosome Number",ylab="SV Numbers")


#####################################
##        ??6?? ֱ??ͼ             ##
#####################################

x <- read.table("Rdata/H37Rv.gff",sep = "\t",header = F,skip = 7,quote = "")
x <- x[x$V3=="gene",]
x <- abs(x$V5-x$V4+1)
length(x)
range(x)
hist(x)
hist(x,breaks = 80)
hist(x,breaks = c(0,500,1000,1500,2000,2500,15000))
hist(x,breaks = 80,freq = F)
hist(x,breaks = 80,density = T)
hist(rivers,density = T,breaks = 10)
?hist
h=hist(x,nclass=80,col="pink",xlab="Gene Length (bp)",main="Histogram of Gene Length");
h
rug(x);
xfit<-seq(min(x),max(x),length=100);
yfit<-dnorm(xfit,mean=mean(x),sd=sd(x));
yfit <- yfit*diff(h$mids[1:2])*length(x);
lines(xfit, yfit, col="blue", lwd=2);

#####################################
##        ??7?? ɢ??ͼ             ##
#####################################
m <- read.table("Rdata/prok_representative.txt",sep="\t");
genome_size <- m[,2];
gene_size <- m[,4];
plot(genome_size,gene_size,pch=16,
     xlab="Genome Size",ylab="Genes");
fit <- lm(gene_size ~ genome_size);
abline( fit,col="blue",lwd=1.8 );
rr <- round( summary(fit)$adj.r.squared,2);
intercept <- round( summary(fit)$coefficients[1],2);
slope <- round( summary(fit)$coefficients[2],2);
eq <- bquote( atop( "y = " * .(slope) * " x + " * .(intercept), R^2 == .(rr) ) );
text(12,6e3,eq);



#####################################
##        ??8?? ??ͼ               ##
#####################################
x <- read.csv("Rdata/homo_length.csv",header = T)
x <- x[1:24,]
barplot(height = x$length,names.arg = x$chr)
pie(x$length/sum(x$length))

m <- read.table("Rdata/Species.txt");
m
x <- m[,3]
pie(x);
pie(x,col=rainbow(length(x)))
lbls <- paste(m[,1],m[,2],"\n",m[,3],"%" )
pie(x,col=rainbow(length(x)),labels = lbls)
pie(x,col=rainbow(length(x)),labels = lbls)
pie(x,col=rainbow(length(x)),labels = lbls,radius = 1)
pie(x,col=rainbow(length(x)),labels = lbls,radius = 1,cex=0.8)

#3D??ͼ
install.packages("plotrix")
library(plotrix)
pie3D(x,col=rainbow(length(x)),labels = lbls)
pie3D(x,col=rainbow(length(x)),labels = lbls,cex=0.8)
pieplot <- pie3D(x,col=rainbow(length(x)),radius = 1,explode = 0.1)
pie3D.labels(pieplot,labels = lbls,labelcex = 0.8,height = 0.1,labelrad = 1.75)

#????ͼ
fan.plot(x,col=rainbow(length(x)),labels = lbls,cex=0.8,radius = 1)



#####################################
##        ??9?? ????ͼ             ##
#####################################
boxplot(mpg ~cyl,data = mtcars)
m <- read.csv("Rdata/gene_expression.csv",header = T,row.names = 1)
head(m)
boxplot(m)
boxplot(m,outline=F)
install.packages("reshape2")
library(reshape2)
x <- melt(m)
head(x)
boxplot(value ~ variable,data = x)
boxplot(value ~ variable,data = x,outline=F)

boxplot(len ~ dose, data = ToothGrowth)
boxplot(len ~ dose:supp, data = ToothGrowth)
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"))
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"),notch=T)
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"),width=c(1,0.5,1,0.5,1,0.5))
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"),varwidth=T)
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"),boxwex=0.5)
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"),staplewex=0.5)
boxplot(len ~ dose:supp, data = ToothGrowth,col = c("orange", "red"),sep = ":",lex.order = T)


#####################################
##        ??10?? par????           ##
#####################################
opar <- par(no.readonly = T)
?par
par()
x <- par()
x$pch
par(pch=16)
opar <- par(no.readonly = T)
opar
par(opar)

plot(women$height,women$weight)
plot(women$height,women$weight,type = "b",pch=16,col="red",lty=2,lwd=2,
     main = "Main Title",sub = "Sub Title",xlab = "Heigth",
     ylab = "Weight",xlim = c(50,100),ylim = c(100,200),cex=1.5,las=3,
     adj=0.3,bty="c",fg="blue",tck=-0.03,col.main="green",cex.lab=2)



#####################################
##        ??11?? ??ɫ              ##
#####################################
colors()
sample(colours(),24)
rgb(0, 1, 0)
hsv(0,1,0)
hcl(0,1,0)

rainbow(7)
pie(1:7,col=rainbow(7))
heat.colors(7)
pie(1:7,col=heat.colors(7))
terrain.colors(7)
pie(1:7,col=terrain.colors(7))
topo.colors(7)
pie(1:7,col=topo.colors(7))
cm.colors(7)
pie(1:7,col=cm.colors(7))
gray.colors(7)
pie(1:7,col=gray.colors(7))

install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()
display.brewer.pal("Set1")
brewer.pal.info
brewer.pal(name = "Set1",n=7)

#####################################
##        ??12?? ??ͼ1             ##
#####################################
#1 heatmap()
#2 gplots ?? heatmap.2()
#3 pheatmap?? pheatmap
#4 ComplexHeatmap??

example("heatmap")
m <- read.csv("Rdata/heatmap.csv",header = T,row.names = 1)
class(m)
x <- as.matrix(m)
heatmap(x)
heatmap(t(x))
heatmap(x,col=c("green","red"))
yanse <- colorRampPalette(c("red","black","green"))(nrow(x))
heatmap(x,col=yanse)
heatmap(x,col=yanse,RowSideColors = yanse)
heatmap(x,col=yanse,ColSideColors = colorRampPalette(c("red","black","green"))(ncol(x)))
heatmap(x,col=yanse,Rowv = NA)
heatmap(x,col=yanse,Rowv = NA,Colv = NA)
heatmap(state.x77)
heatmap(state.x77,scale = "col")

#####################################
##        ??13?? ??ͼ2             ##
#####################################
#install.packages("gplots")
library(gplots)
heatmap.2(x)
example(heatmap.2)
heatmap.2(x)
heatmap.2(x,key = F)
heatmap.2(x,symkey = F)
heatmap.2(x,symkey = T,density.info = "none")
heatmap.2(x,symkey = T,trace = "none")
heatmap.2(x,symkey = T,tracecol = "black")
heatmap.2(x,dendrogram = "none")
heatmap.2(x,dendrogram = "row")
heatmap.2(x,dendrogram = "col")

#install.packages("pheatmap")
library(pheatmap)
example("pheatmap")
pheatmap(x)
annotation_col <- data.frame(CellType=factor(rep(c("N1","T1","N2","T2"),each=5)))
rownames(annotation_col) <- colnames(x)
pheatmap(x,annotation_col = annotation_col)
pheatmap(x,annotation_col = annotation_col,display_numbers = T)
pheatmap(x,annotation_col = annotation_col,display_numbers = T,number_format = "%.2f")
pheatmap(x,annotation_col = annotation_col,display_numbers = T,number_format = "%.1f",number_color = "black")

#####################################
##        ??14?? Τ??ͼ            ##
#####################################
#install.packages("VennDiagram")
listA <- read.csv("Rdata/genes_list_A.txt",header=FALSE)
A <- listA$V1
listB <- read.csv("Rdata/genes_list_B.txt",header=FALSE)
B <- listB$V1
listC <- read.csv("Rdata/genes_list_C.txt",header=FALSE)
C <- listC$V1
listD <- read.csv("Rdata/genes_list_D.txt",header=FALSE)
D <- listD$V1
listE <- read.csv("Rdata/genes_list_E.txt",header=FALSE)
E <- listE$V1
length(A);length(B);length(C);length(D);length(E)
library(VennDiagram)
venn.diagram(list(C = C, D = D),fill = c("yellow","cyan"), cex = 1.5,filename = "venn2.png")
venn.diagram(list(A = A, C = C, D = D), fill = c("yellow","red","cyan"), cex = 1.5,filename="venn3.png")
venn.diagram(list(A = A, B = B, C = C, D = D), fill = c("yellow","red","cyan","forestgreen"), cex = 1.5,filename="venn4.png")
venn.diagram(list(A = A, B = B, C = C, D = D , E = E ), fill = c("yellow","red","cyan","forestgreen","lightblue"), cex = 1.5,filename="venn5.png")



#####################################
##        ??15?? ??????ͼ          ##
#####################################
install.packages("qqman")
library(qqman)
library(RColorBrewer)
str(gwasResults)
head(gwasResults)
manhattan(gwasResults)
manhattan(gwasResults, main = "Manhattan Plot", ylim = c(0, 6), cex = 0.6,cex.axis = 0.9, col = c("blue4", "orange3"), suggestiveline =
            F, genomewideline = F,chrlabs = c(1:20, "P", "Q"))
unique(gwasResults$CHR)
number <- length(unique(gwasResults$CHR))
yanse <- brewer.pal(n = 4,name = "Set1")
manhattan(gwasResults, main = "Manhattan Plot", ylim = c(0, 6), cex = 0.6,cex.axis = 0.9, col = yanse, suggestiveline =
            F, genomewideline = F,chrlabs = c(1:20, "P", "Q"))


manhattan(subset(gwasResults,CHR==3))
#??????ʾ????SNP????
snpsOfInterest
manhattan(gwasResults, highlight = snpsOfInterest)

#ע??SNP????
manhattan(gwasResults, annotatePval = 0.001)
manhattan(gwasResults, annotatePval = 0.001, annotateTop = FALSE)
#???????ݿ??Բ鿴manhattan??qqman?İ????ĵ?
help("manhattan")
vignette("qqman")

#####################################
##        ??16?? ??ɽͼ            ##
#####################################
m <- read.csv("Rdata/Deseq2.csv",header = T,row.names = 1)
head(m)
m <- na.omit(m)
plot(m$log2FoldChange,m$padj)
plot(m$log2FoldChange,-1*log10(m$padj))
plot(m$log2FoldChange,-1*log10(m$padj),xlim = c(-10,10),ylim=c(0,100))
m <- transform(m,padj=-1*log10(m$padj))
down <- m[m$log2FoldChange<=-1,] 
up <- m[m$log2FoldChange>=1,]
no <- m[m$log2FoldChange>-1 & m$log2FoldChange <1,] 

plot(no$log2FoldChange,no$padj,xlim = c(-10,10),ylim=c(0,100),col="blue",pch=16,cex=0.8,main = "Gene Expression",xlab = "log2FoldChange",ylab="-log10(Qvalue)")
points(up$log2FoldChange,up$padj,col="red",pch=16,cex=0.8)
points(down$log2FoldChange,down$padj,col="green",pch=16,cex=0.8)


#####################################
##        ??17?? GC-depthͼ        ##
#####################################
opar <- par(no.readonly = T)
par(mfrow=c(2,3))
plot(pressure)
m <- read.table("Rdata/GC-depth.txt");
head(m)
nf <- layout(matrix(c(0,2,0,0,1,3),2,3,byrow=T),c(0.5,3,1),c(1,3,0.5),TRUE);
par(mar=c(5,5,0.5,0.5));
layout.show(3)
par("mar")
par(mar=c(5,5,0.5,0.5));
x <- m[,1];
y <- m[,2];
plot(x,y,xlab='GC Content(%)',ylab='Depth',pch=16,col="#FF000077",xlim=c(0,100),ylim=c(0,max(y)))
hist(x,breaks = 100)

xhist <- hist(x,breaks=100,plot=FALSE);
yhist <- hist(y,breaks=floor(max(y)-0),plot=FALSE);

par(mar=c(0,5,1,1));
barplot(xhist$counts,space=0,xlim=c(0,100) );

par(mar=c(5,0,1,1));
barplot(yhist$counts,space=0,horiz=TRUE,ylim=c(0,max(y) ) );


#####################################
##        ??18?? COGע??ͼ         ##
#####################################
m <- read.table("Rdata/cog.class.annot.txt",head=T,sep="\t");
head(m)
layout(matrix(c(1,2),nr=1),widths=c(20,13));
layout.show(2)
par( mar=c(3,4,4,1)+0.1 );

class <- c("J","A","K","L","B","D","Y","V","T","M","N","Z","W","U","O","C","G","E","F","H","I","P","Q","R","S");
t <- factor( as.character(m$Code),levels=class )
m <- m[order(t),]

barplot(m$Gene.Number,space=F,col=rainbow(25),ylab="Number of genes",names.arg = m$Code)

l <- c(0,5,15,23,25);
id<- c("INFORMATION STORAGE\nAND PROCESSING","CELLULAR PROCESSES\nAND SIGNALING","METABOLISM","POORLY\nCHARACTERIZED")
abline( v = l[c(-1,-5)]);

for( i in 2:length(l) ){
  text( (l[i-1]+l[i])/2,max(m[,3])*1.1,id[i-1],cex=0.8,xpd=T)
}

par(mar=c(2,0,2,1)+0.1 );
plot(0,0,type="n",xlim=c(0,1),ylim=c(0,26),bty="n",axes=F,xlab="",ylab="")

for( i in 1:length(class) ){
  text(0,26-i+0.5,paste(m$Code[i],m$Functional.Categories[i]),pos=4,cex=1,pty=T)
}
title(main = "COG function classification");




#####################################
##        ??19?? GO??Ŀͼ          ##
#####################################
library(ggplot2)

go <- read.csv("Rdata/go.csv",header = T)
head(go)
go_sort <- go[order(go$Ontology,-go$Percentage),]
m <- go_sort[go_sort$Ontology=="Molecular function",][1:10,]
c <- go_sort[go_sort$Ontology=="Cellular component",][1:10,]
b <- go_sort[go_sort$Ontology=="Biological process",][1:10,]
slimgo <- rbind(b,c,m)

#??????Ҫ??Tremת??Ϊ????
slimgo$Term=factor(slimgo$Term,levels=slimgo$Term)

colnames(slimgo)
pp <- ggplot(data = slimgo, mapping = aes(x=Term,y=Percentage,fill=Ontology))
pp
pp+geom_bar(stat="identity")
pp+geom_bar(stat="identity")+coord_flip()
pp+geom_bar(stat="identity")+coord_flip()+scale_x_discrete(limits=rev(levels(slimgo$Term)))
pp+geom_bar(stat="identity")+coord_flip()+scale_x_discrete(limits=rev(levels(slimgo$Term)))+guides(fill=FALSE)
pp+geom_bar(stat="identity")+coord_flip()+scale_x_discrete(limits=rev(levels(slimgo$Term)))+guides(fill=FALSE)+theme_bw()


#####################################
##        ??20?? keggͼ            ##
#####################################
library(ggplot2)

pathway <-  read.csv("Rdata/kegg.csv",header=T)
head(pathway)
colnames(pathway)

pp <-  ggplot(data=pathway,mapping = aes(x=richFactor,y=Pathway))
pp
pp + geom_point()
pp + geom_point(aes(size=AvsB))
pp + geom_point(aes(size=AvsB,color=Qvalue))
pp + geom_point(aes(size=AvsB,color=Qvalue)) + scale_colour_gradient(low="green",high="red")
pp + geom_point(aes(size=AvsB,color=Qvalue)) + scale_colour_gradient(low="green",high="red")+labs(title="Top20 of pathway enrichment",x="Rich factor",y="Pathway Name",color="-log10(Qvalue)",size="Gene Numbers")
pp + geom_point(aes(size=AvsB,color=Qvalue)) + scale_colour_gradient(low="green",high="red")+labs(title="Top20 of pathway enrichment",x="Rich factor",y="Pathway Name",color="-log10(Qvalue)",size="Gene Numbers")+theme_bw()

# 教程url:https://www.bilibili.com/video/BV1XJ411m73p?p=19