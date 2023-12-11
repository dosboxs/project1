k=11;
s = sprintf('voice_data4/%i.wav',6); 
[s1 fs1] = audioread(s);%读取
v = mfcc(s1, fs1);%提取特征参数
a= vqlbg(v, k); %量化
a=a(:);
b=mapminmax('apply',a,settings);%归一
YY=sim(net,b);
[maxi,ypred]=max(YY);
leibie = ypred  %显示类别标签

res = strs{leibie}