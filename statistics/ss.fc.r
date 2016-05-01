# 2016-05-01 SUN
# Yeast HD LD Rho project

ss.fc = function(data,group) { # Not complete function, yet
	group.lv = levels(group)
	n = length(group.lv)
	cat('Level(s) of group =',group.lv,'\n\n')
	avs = NULL
  
	# Step 1. Calculate average of each group
	for(i in 1:n) {
		av = apply(data[,which(group==group.lv[i])],1,mean)
		avs = cbind(avs,av)
	}
	colnames(avs) = group.lv # set colnames of avs df
	print(head(avs))

	# Step 2. Calculate fold-changes by every combination
	comb = combn(n,2) # compute combination
	m = length(comb[1,])
	fcs = NULL
	fc.col = NULL
	for(i in 1:m) {
		fc.col = c(fc.col,paste(group.lv[comb[2,i]],'/',
								group.lv[comb[1,i]],sep=""))
		cat('Process =',i,'/',m,'\n')
		fc = avs[,comb[2,i]]-avs[,comb[1,i]]
		fcs = cbind(fcs, fc)
	}
	colnames(fcs) = fc.col
	print(head(fcs))
	fcs2 = apply(fcs,2,function(x){ifelse(x<0,-2^(-x),2^x)}) # apply: 1-rows, 2-columns
	print(head(fcs2))
  
	# Step 3. Collect results
	out = as.data.frame(cbind(avs,fcs,fcs2))
	return(out)
}

fc.cerev = as.data.frame(ss.fc(sgnl.cerev,group))