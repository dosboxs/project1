k=11;
s = sprintf('voice_data4/%i.wav',6); 
[s1 fs1] = audioread(s);%��ȡ
v = mfcc(s1, fs1);%��ȡ��������
a= vqlbg(v, k); %����
a=a(:);
b=mapminmax('apply',a,settings);%��һ
YY=sim(net,b);
[maxi,ypred]=max(YY);
leibie = ypred  %��ʾ����ǩ

res = strs{leibie}