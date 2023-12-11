clc
clear

k = 11;
data_matrix=[];%����ѵ������
data_matrix2=[];%�����������

%Ԫ�����飬�±��1��ʼ
strs = {'��','Ҫ','һ��','����','����','����','����','����','ţ��'}

%��Ҫ: ��ͷ�����ִ���ĺ���
%0 NAN ����
%1 strs{1} = '��';
%2 strs{2} = 'Ҫ';
%3 strs{3} = 'һ��';
%4 strs{4} = '����';
%5 strs{5} = '����';
%6 strs{6} = '����';
%7 strs{8} = '����';
%8 strs{9} = '����';
%9 strs{10} = 'ţ��';
%  ...   ...   ...

%0~9ÿ������¼10�飬ѵ������Ϊ00��01��02��... ��09
%��������Ϊ000��001��002��... ��009
%ÿ�������ٷֱ�¼��һ�� 0��1��2��... ��9

%����ѵ�����ݣ�����ȡ����
T_train=[];
%T_test=[];
for i=1:9
    for j=1:9
        s = sprintf('voice_data4/train/%i%i.wav',i,j);%�Ѹ�ʽ��������д��ĳ���ַ�����
        [s1 fs1] = audioread(s);%��ȡ
        v = mfcc(s1, fs1);%��ȡ��������
        a = vqlbg(v, k); %����
        data_matrix=[data_matrix,a(:)];
        T_train=[T_train,i];
    end
end

%{
 %����������ݣ�����ȡ����
for i=1:9
    for j=1:5
        s = sprintf('voice_data4/test/%i0%i.wav',i,j);
        [s1 fs1] = audioread(s);
        v = mfcc(s1, fs1);
        a= vqlbg(v, k); 
        data_matrix2=[data_matrix2,a(:)];
        T_test=[T_test,i+1];
    end
end
%}

%�����ı�ǩ
%��data_matrix��һ�������P_train���ڷ�Χ��0,1���ڣ���һ����Ҫ��Ϊ��������ͬ���ٶԽ����Ӱ��
[P_train,settings] = mapminmax(data_matrix,0,1);
Tn_train=BP(T_train');

%��������ǰ��������,������ԪΪ200�������ԪΪ10��traingda ����Ӧlr�ݶ��½���
%���ز㼤��� tansig��sigmoid������
net=newff(minmax(P_train),[200,9],{'tansig' 'tansig'},'traingda');

%���������ѵ������
net.trainParam.show=500;         % show����ʾ�ļ��������Ĭ�ϣ�25
net.trainParam.lr=0.5;           % lr��ѧϰ�ʣ�Ĭ�ϣ�0.01
net.trainParam.epochs=5000;      % epochs��ѵ���Ĵ�����Ĭ�ϣ�100 %ѵ������ȡ5000
net.trainParam.goal=0.01;        % goal���������Ŀ��ֵ��Ĭ�ϣ�0 %�������ȡ0.001

%���� traingda �㷨ѵ�� BP ����
net=train(net,P_train,Tn_train); %ѵ��������
YY=sim(net,P_train); %�� BP ������з���

%{
[maxi,ypred]=max(YY);
%maxi=maxi';
ypred=ypred';
CC=ypred-T_train';
n=length(find(CC==0));
Accuracytrain=n/size(P_train,2);%��ʶ��ı�ǩ����ʵ�ı�ǩ��һ���ĸ���,�Ӷ��������ȷ��

YY=sim(net,P_test);
[~,ypred]=max(YY);
%maxi=maxi';
ypred=ypred';
CC=ypred-T_test';
n=length(find(CC==0));
Accuracytest=n/size(P_test,2);
%}

%��ȡ��������
s = sprintf('voice_data4/%i.wav',6); 
[s1 fs1] = audioread(s);%��ȡ
v = mfcc(s1, fs1);%��ȡ��������
a= vqlbg(v, k); %����
a=a(:);
b=mapminmax('apply',a,settings);%��һ������
YY=sim(net,b);
[maxi,ypred]=max(YY);
leibie = ypred  %��ʾ����ǩ

res = strs{leibie}

save('neting.mat','settings','net'); 